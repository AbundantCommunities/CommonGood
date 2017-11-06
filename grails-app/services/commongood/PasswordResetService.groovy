package commongood

import grails.transaction.Transactional

//import org.apache.xml.resolver.CatalogManager

// For generating random tokens
import com.cognish.password.FreshRandomness
import com.cognish.password.HashSpec
import com.cognish.password.Hasher

// For emailing via MailGun
import static groovyx.net.http.HttpBuilder.configure
import static groovyx.net.http.ContentTypes.JSON
import groovyx.net.http.*
import static groovy.json.JsonOutput.prettyPrint

@Transactional
class PasswordResetService {

    FreshRandomness fresher = new FreshRandomness( )
    static private String EmailDomainName = System.getenv("CG_EMAIL_DOMAIN")
    static private String EmailPrivateKey = System.getenv("CG_EMAIL_PRIVATE_KEY")
    static {
        // ALSO: throw exception if those environment variables are not found
        println "\n~~~~~~~~~~~~~~~~~~  REMOVE THIS CODE!  ~~~~~~~~~~~~~~~~~~"
        println "EmailDomainName = ${EmailDomainName}"
        println "EmailPrivateKey = ${EmailPrivateKey}"
        println "~~~~~~~~~~~~~~~~~~  REMOVE THIS CODE!  ~~~~~~~~~~~~~~~~~~\n"
    }

    // Send a reset email and return a new PasswordReset
    // (but no email and return null if emailAddress fails database tests)
    PasswordReset sendEmail( String emailAddress ) {
        Person person = emailAddressIsOkay( emailAddress )
        if( person ) {
            println "SHOULD SEND EMAIL to MAILGUN"
            Date expiresAt
            use( groovy.time.TimeCategory ) {
                expiresAt = 6.hours.from.now
            }
            byte[] randy = new byte[32]
            fresher.get( randy )
            def token = randy.encodeHex().toString()
            def reset = new PasswordReset( token:token, emailAddress:emailAddress,
                            expiryTime:expiresAt, state:"Active" )
            reset.save( flush:true, failOnError: true )

            sendEmail( emailAddress, token )
            return reset
        } else {
            return null
        }
    }

    // Find the random token in the PasswordReset table
    Tuple2 get( String token ) {
        // TODO Probably should index PasswordReset table by token
        def reset = PasswordReset.findByToken( token )
        if( reset ) {
            if( reset.state.equals("Active") ) {
                if( new Date() < reset.expiryTime ) {
                    return new Tuple2( "okay", reset )
                } else {
                    log.info "${reset.moniker} is stale"
                    return new Tuple2( "stale", reset )
                }
            } else {
                log.info "${reset.moniker} is not active"
                return new Tuple2( "inactive", reset )
            }
        } else {
            // Worried this may be an attack, but maybe super old reset email
            log.warn "UNEXPECTED: Password reset token not on file: ${token}"
            return new Tuple2( "nof", new PasswordReset() ) // Can't put a null in a Tuple2
        }
    }

    def reset( PasswordReset reset, String password ) {
        def person = Person.findByEmailAddress( reset.emailAddress )
        if( person ) {
            // Get reset again, so it can be part of this Hibernate Transaction
            reset = PasswordReset.findByToken( reset.token )
            if( !reset ) {
                log.warn "SHOULD BE TESTING EVEN MORE THOROUGHLY !!!!"
                return false
            }
            String hashed = hashPassword( password )
            person.hashedPassword = hashed
            person.save( flush:true, failOnError: true )

            reset.state = "Used"
            reset.save( flush:true, failOnError: true )

            log.info "Changed the password for ${person.logName}"
            return true
        } else {
            log.warn "SOMEHOW password reset's email address no longer on file ${reset.moniker}"
            return false
        }
    }

    private Person emailAddressIsOkay( String emailAddress ) {
        def person = Person.findByEmailAddress( emailAddress )
        if( !person ) {
            log.warn "No person with email address ${emailAddress}"
            return null
        }
        if( !person.appUser ) {
            log.warn "${person.logName} is not an appUser"
            return null
        }
        def da = DomainAuthorization.findByPerson( person )
        if( !da ) {
            log.warn "${person.logName} has no DomainAuthorization"
            return null
        }
        return person
    }

    def sendEmail( String address, String token ) {
        log.info "Send password reset email to ${address} with token ${token}"
        def result = configure {
            // request.uri is the only required property, though other global and client configurations may be configured
            request.uri = "https://api.mailgun.net"
            request.contentType = JSON[0]
            request.auth.digest 'api', "${EmailPrivateKey}"
        }.post {
            request.uri.path = "/v3/${EmailDomainName}/messages"
            request.body = [from: "CommonGood NO REPLY<no-reply@${EmailDomainName}>",
                to:address,
                subject: "CommonGood Password Reset",
                text: "You go, boy! http://localhost:8080/CommonGood/passwordReset/getNew?token=${token}"]
            request.contentType = 'application/x-www-form-urlencoded'
            request.encoder 'application/x-www-form-urlencoded', NativeHandlers.Encoders.&form
            log.info "MailGun request: ${request}"
        }

        println "Response: ${result}"
    }

    def hashPassword( String password ) {
        // Neat thing is: one can change the parameters here without affecting
        // the existing password hashes.
        HashSpec spec = new HashSpec( "PBKDF2WithHmacSHA512", 75000, 64, 256 )
        Hasher hasher = new Hasher( spec )
        return hasher.create( password.toCharArray() )
    }
}
