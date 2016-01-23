package commongood

class FamilyController {
    static allowedMethods = [members:'GET', save:'POST']

    def members( ) {
        def id = Long.valueOf( params.id )
        def famAddresses = Person.findAll("from Person p join p.family as f where f.id=?", [ id ])

        def result = [ ]
        famAddresses.each {
            Person member = it[0]
            result << [ id:member.id, name:member.fullName ]
        }

        def bldr = new groovy.json.JsonBuilder( result )
        def writer = new StringWriter()
        bldr.writeTo(writer)
        render writer
    }

    def save() {
        Family family
        def interviewed
        if( 'id' in params ) {
            // The request wants us to change an existing family.
            // We will not change the family's address.
            def familyId = Long.valueOf( params.id )
            println "Request to CHANGE family ${familyId}"
            family = Family.get( familyId )
            interviewed = family.getInterviewed( )
        } else {
            // The request is to create a new family.
            // We need to get the family's address from the request.
            family = new Family( )
            def addressId = Long.valueOf( params.addressId )
            println "Request to add a family to address ${addressId}"
            family.address = Address.get( addressId )
            interviewed = Boolean.FALSE
        }

        if( interviewed ) {
            family.interviewer = Person.get( Long.valueOf( params.interviewerId ) )
            family.interviewDate = new Date( ).parse( 'yyyy-MM-dd', params.initialInterviewDate )
        }
        family.name = params.familyName
        family.participateInInterview = ('participateInInterview' in params)
        family.permissionToContact = ('permissionToContact' in params)
        family.note = params.note
        family.orderWithinAddress = Integer.valueOf( params.orderWithinAddress ?: '100' )

        // TODO Replace failOnError with logic
        family.save( flush:true, failOnError: true )
        forward controller:'navigate', action:'family', id:family.id
    }
}
