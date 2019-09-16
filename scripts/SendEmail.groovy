@Grab('io.github.http-builder-ng:http-builder-ng-core:1.0.0')

// For production we implement sending emails in PasswordResetService

import static groovyx.net.http.HttpBuilder.configure
import static groovyx.net.http.ContentTypes.JSON
import groovyx.net.http.*
import static groovy.json.JsonOutput.prettyPrint

String YOUR_DOMAIN_NAME = "em.abundantcommunityinitiative.org"

println "Enter the MailGun private API key for ${YOUR_DOMAIN_NAME}"
def privateKey = System.in.newReader().readLine()

def result = configure {
    // request.uri is the only required property, though other global and client configurations may be configured
    request.uri = "https://api.mailgun.net"
    request.contentType = JSON[0]
    request.auth.digest 'api', "${privateKey}"
}.post {
    request.uri.path = "/v3/${YOUR_DOMAIN_NAME}/messages"
    request.body = [from: "Testy McTester <testy@${YOUR_DOMAIN_NAME}>",
        to:"canuckisman@gmail.com",
        subject: "CommonGood password reset",
        text: "Never commit a private key to GitHub!!"]
    request.contentType = 'application/x-www-form-urlencoded'
    request.encoder 'application/x-www-form-urlencoded', NativeHandlers.Encoders.&form
}

println "Response: ${result}"
