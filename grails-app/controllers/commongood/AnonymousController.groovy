package commongood

import org.abundantcommunityinitiative.commongood.handy.JsonWriter

class AnonymousController {
    static allowedMethods = [hello:'POST']

    // http://localhost:8080/CommonGood/anonymous/hello?neighbourhoodId=203&requestContext=activities&requestReference=bowling&residentName=Marco&emailAddress=marco@gmail.com&homeAddress=9301+93+St&phoneNumber=123-456-7890&comment=Sign+me+up
    def hello( ) {
        log.info "Anon says hoodId=${params.neighbourhoodId}, reqCtx=${params.requestContext}, " +
                "reqRef=${params.requestReference}, name=${params.residentName}, email=${params.emailAddress}, " +
                " addr=${params.homeAddress}, phone=${params.phoneNumber}, comment=${params.comment}"

        def result
        def hood = Neighbourhood.get( params.long('neighbourhoodId') )
        
        if( hood ) {
            if( hood.acceptAnonymousRequests ) {
                def ar = new AnonymousRequest( )
                ar.neighbourhood = hood
                ar.residentName = params.residentName
                ar.emailAddress = params.emailAddress
                ar.homeAddress = params.homeAddress
                ar.phoneNumber = params.phoneNumber
                ar.comment = params.comment
                // write code to get ip address
                ar.ipAddress = '1.2.3.4'
                ar.requestContext = params.requestContext
                ar.requestReference = params.requestReference
                ar.save( flush:true, failOnError: true )
                result = [ status: 0, text: 'Success' ]
            } else {
                result = [ status: 1, text: 'Neighbourhood refuses anonymous requests' ]
            }
        } else {
            // No such neighbourhood
            result = [ status : 2, text: 'No such neighbourhood' ]
        }

        render JsonWriter.write( result )
    }
}