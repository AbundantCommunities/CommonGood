package commongood

class SaveFamilyController {
//  static allowedMethods = [index:'POST']

// http://localhost:8080/CommonGood/saveFamily/index/2?name=Wertzworth&participateInInterview=F&permissionToContact=T&note=Good+times
// http://localhost:8080/CommonGood/navigate/family/2

    def index() {
        def name = params.name
        def participate = ('participateInInterview' in params)
        def permission = ('permissionToContact' in params)
        def note = params.note

        println "familyName=${name} participateInInterview=${participate} permissionToContact=${permission} note=${note}"

        if( 'id' in params ) {
            // The request wants us to change an existing family
            def familyId = Long.valueOf( params.id )
            println "Request to CHANGE family ${familyId}"
            def family = Family.get( familyId )
            family.name = name
            family.participateInInterview = participate
            family.permissionToContact = permission
            family.note = note
//          family.save(failOnError: true)
            family.save(flush: true)
            family.errors.each {
               println it
            }
            forward controller:'navigate', action:'family', id:familyId
        } else {
            // The request is to create a new family
            println "Request to CREATE a new family"
        }
    }
}
