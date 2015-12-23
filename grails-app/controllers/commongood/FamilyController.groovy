package commongood

class FamilyController {
//  static allowedMethods = [index:'POST']

// http://localhost:8080/CommonGood/family/save/2?name=Wertzworth&participateInInterview=F&permissionToContact=T&note=Good+times
// http://localhost:8080/CommonGood/navigate/family/2

    def save() {
        def addressId = Long.valueOf( params.addressId )
        def interviewerId = Long.valueOf( params.interviewerId )
        def name = params.familyName
        def participate = ('participateInInterview' in params)
        def permission = ('permissionToContact' in params)
        def interviewDate = new Date( ).parse( 'yyyy-MM-dd', params.initialInterviewDate )
        def note = params.note
        def orderWithin = params.orderWithinAddress

        println "familyName=${name} participateInInterview=${participate} permissionToContact=${permission} note=${note}"

        if( 'id' in params ) {
            println "Request to CHANGE family ${familyId}"
            // The request wants us to change an existing family
            def familyId = Long.valueOf( params.id )
            def family = Family.get( familyId )
            faily.address = Address.get( addressId )
            family.interviewer = Person.get( interviewerId )
            family.name = name
            family.participateInInterview = participate
            family.permissionToContact = permission
            family.note = note
            family.interviewDate = interviewDate
            family.order = orderWithin
            // TODO Test: family.save(failOnError: true)
            family.save( flush:true )
            forward controller:'navigate', action:'family', id:familyId
        } else {
            // The request is to create a new family
            Family family = new Family( )
            faily.address = Address.get( addressId )
            family.interviewer = Person.get( interviewerId )
            family.name = name
            family.participateInInterview = participate
            family.permissionToContact = permission
            family.note = note
            family.interviewDate = interviewDate
            family.order = orderWithin
            family.save( flush:true )
        }
    }
}
