package commongood

class SaveFamilyController {
//  static allowedMethods = [index:'POST']

// http://localhost:8080/CommonGood/saveFamily/index/2?name=Claus&participateInInterview=T&permissionToContact=F&note=LMAO
// http://localhost:8080/CommonGood/navigate/family/2

    def index() {
        def name = params.name
        def participate = params.participateInInterview
        def permission = params.permissionToContact
        def note = params.note

        println "familyName=${name} participateInInterview=${participate} permissionToContact=${permission} note=${note}"
        println "${name.class.name} ${participate.class.name} ${permission.class.name} ${note.class.name}"

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
