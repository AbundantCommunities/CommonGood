package commongood

class SaveFamilyController {
//  static allowedMethods = [index:'POST']

// http://localhost:8080/CommonGood/saveFamily/index/2?name=Wertzworth&participateInInterview=F&permissionToContact=T&note=Good+times
// http://localhost:8080/CommonGood/navigate/family/2

    def index() {
        def name = params.familyName
        def participate = ('participateInInterview' in params)
        def permission = ('permissionToContact' in params)
        def inDate = new Date( params.initialInterviewDate )
        def note = params.note
        def orderWithin = params.orderWithinAddress

        println "familyName=${name} participateInInterview=${participate} permissionToContact=${permission} note=${note}"

        if( 'id' in params ) {
            println "Request to CHANGE family ${familyId}"
            // The request wants us to change an existing family
            def familyId = Long.valueOf( params.id )
            def family = Family.get( familyId )
            family.name = name
            family.participateInInterview = participate
            family.permissionToContact = permission
            family.note = note
            family.interviewDate = inDate
            family.order = orderWithin
            // TODO Test: family.save(failOnError: true)
            family.errors.each {
               println it
            }
            family.save(flush: true)
            forward controller:'navigate', action:'family', id:familyId
        } else {
            // The request is to create a new family
            render 'Request to CREATE a new family -- not implemented'
        }
    }
}
