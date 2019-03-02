package commongood

import grails.transaction.Transactional

// For generating random tokens
import com.cognish.password.FreshRandomness
import com.cognish.password.HashSpec
import com.cognish.password.Hasher

// For emailing via MailGun
import static groovyx.net.http.HttpBuilder.configure
import static groovyx.net.http.ContentTypes.JSON
import groovyx.net.http.*

@Transactional
class PasswordResetService {

    def grailsApplication

    def getAbsoluteURL( String path ) {
        // path should begin with the slash character, like "/myController/myAction"
        def g = grailsApplication.mainContext.getBean('org.codehaus.groovy.grails.plugins.web.taglib.ApplicationTagLib')
        def absoluteURL = g.createLink( absolute:true, uri:path )
        println ".... ABSOLUTE URL: ${absoluteURL}"
        return absoluteURL
    }

    // For hashing new password
    FreshRandomness fresher = new FreshRandomness( )

    static private String emailDomainName = System.getenv("CG_EMAIL_DOMAIN")
    static private String emailPrivateKey = System.getenv("CG_EMAIL_PRIVATE_KEY")
    static {
        if( emailDomainName && emailPrivateKey ) {
            println "Picked up CG_EMAIL_DOMAIN = ${emailDomainName}"
        } else {
            throw new RuntimeException("Missing environment variable(s) CG_EMAIL_DOMAIN and/or CG_EMAIL_PRIVATE_KEY")
        }
    }

    // Send a reset email and return a new PasswordReset
    // (but no email and return null if emailAddress fails database tests)
    PasswordReset sendEmail( String emailAddress ) {
        Person person = emailAddressIsOkay( emailAddress )
        if( person ) {
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

            sendToMailGun( person, token )
            return reset
        } else {
            return null
        }
    }

    // Find the random token in the PasswordReset table. The Tuple2 we return has
    // (1) a string code indicating how well we did fetching the token and 
    // (2) the PasswordReset we found.
    Tuple2 get( String token ) {
        // TODO Probably should index PasswordReset table by token
        def reset = PasswordReset.findByToken( token )
        if( reset ) {
            if( reset.state.equals("Active") ) {
                if( new Date() < reset.expiryTime ) {
                    return new Tuple2( "okay", reset )
                } else {
                    log.info "${reset} is stale"
                    return new Tuple2( "stale", reset )
                }
            } else {
                log.info "${reset} is not active"
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
            log.warn "SOMEHOW password reset's email address no longer on file ${reset}"
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

    private sendToMailGun( Person person, String token ) {
        log.info "Send password reset email to ${person.logName} with token ${token}"
        def result = configure {
            // request.uri is the only required property, though other global and client configurations may be configured
            request.uri = "https://api.mailgun.net"
            request.contentType = JSON[0]
            request.auth.digest 'api', "${emailPrivateKey}"
        }.post {
            def resetURL = getAbsoluteURL( "/passwordReset/getNew?token=${token}" )
            log.info "Email will link to ${resetURL}"
            request.uri.path = "/v3/${emailDomainName}/messages"
            request.body = [from: "NO REPLY<no-reply@${emailDomainName}>",
                to:person.emailAddress,
                subject: "CommonGood Password Reset",
                text:
"""Hi ${person.fullName}

Someone (hopefully you!) submitted your email address, in order to change your CommonGood password.

To reset your password click here: ${resetURL}

Happy neighbouring!
"""]
            request.contentType = 'application/x-www-form-urlencoded'
            request.encoder 'application/x-www-form-urlencoded', NativeHandlers.Encoders.&form
        }

        log.info "MailGun result: ${result}"
    }

    def hashPassword( String password ) {
        // Neat thing is: one can change the parameters here without affecting
        // the existing password hashes.
        HashSpec spec = new HashSpec( "PBKDF2WithHmacSHA512", 75000, 64, 256 )
        Hasher hasher = new Hasher( spec )
        return hasher.create( password.toCharArray() )
    }
}
