package commongood

class FamilyController {
    static allowedMethods = [save:'POST']

    def save() {
        Family family
        if( 'id' in params ) {
            // The request wants us to change an existing family.
            // We will not change the family's address.
            def familyId = Long.valueOf( params.id )
            println "Request to CHANGE family ${familyId}"
            family = Family.get( familyId )
        } else {
            // The request is to create a new family.
            // We need to get the family's address from the request.
            family = new Family( )
            def addressId = Long.valueOf( params.addressId )
            println "Request to add a family to address ${addressId}"
            family.address = Address.get( addressId )
        }

        family.interviewer = Person.get( Long.valueOf( params.interviewerId ) )
        family.name = params.familyName
        family.participateInInterview = ('participateInInterview' in params)
        family.permissionToContact = ('permissionToContact' in params)
        family.note = params.note
        family.interviewDate = new Date( ).parse( 'yyyy-MM-dd', params.initialInterviewDate )
        family.orderWithinAddress = Integer.valueOf( params.orderWithinAddress )

        // TODO Replace failOnError with logic
        family.save( flush:true, failOnError: true )
        forward controller:'navigate', action:'family', id:family.id
    }
}
