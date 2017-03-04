package commongood

class AnonymousController {

    // http://localhost:8080/CommonGood/anonymous/hello?neighbourhoodId=203&requestContext=activities&requestReference=bowling&residentName=Marco&emailAddress=marco@gmail.com&homeAddress=9301+93+St&phoneNumber=123-456-7890&comment=Sign+me+up
    def hello( ) {
        log.info "Anon says hoodId=${params.neighbourhoodId}, reqCtx=${params.requestContext}, " +
                "reqRef=${params.requestReference}, name=${params.residentName}, email=${params.emailAddress}, " +
                " addr=${params.homeAddress}, phone=${params.phoneNumber}, comment=${params.comment}"

        render "howdie, neighbour"
    }
}
