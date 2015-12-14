package commongood

class SaveFamilyController {
//  static allowedMethods = [index:'POST']

    def index() {
        if( 'id' in params ) {
            // The request wants us to change an existing family
            def familyId = Integer.valueOf( params.id )
            println "Request to CHANGE family ${familyId}"
        } else {
            // The request is to create a new family
            println "Request to CREATE a new family"
        }

        def name = params.familyName
        def interview = params.participateInInterview
        def contact = params.permissionToContact

        println "familyName=${name} participateInInterview=${interview} permissionToContact=${contact}"
    }
}
