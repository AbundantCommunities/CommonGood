package commongood

class PersonController {
    static allowedMethods = [save:'POST', setBlockConnector:'POST']

    def save() {
        Person person
        if( 'id' in params ) {
            def personId = Long.valueOf( params.id )
            println "Request to CHANGE person ${personId}"
            person = Person.get( personId )
        } else {
            // The request is to create a new person
            def familyId = Long.valueOf( params.familyId )
            println "Request to ADD a person to family ${familyId}"
            person = new Person( )
            person.family = Family.get( familyId )
        }

        person.firstNames = params.firstNames
        person.lastName = params.lastName
        person.birthYear = Integer.valueOf( params.birthYear )
        person.emailAddress = params.emailAddress
        person.phoneNumber = params.phoneNumber
        person.orderWithinFamily = Integer.valueOf( params.orderWithinFamily )

        // TODO Replace failOnError with logic
        person.save( flush:true, failOnError: true )
        forward controller:'navigate', action:'familymember', id:person.id
    }

    def setBlockConnector( ) {
        Long id = Long.parseLong( params.id )
        Person person = Person.get( id )
        def blockId = person.family.address.block.id

        // The person becomes a BC for his block
        DomainAuthorization da = new DomainAuthorization( )
        da.person = person
        da.primaryPerson = Boolean.FALSE
        da.domainCode = DomainAuthorization.BLOCK
        da.domainKey = blockId as Integer
        da.save( flush:true, failOnError: true )
        forward controller:'navigate', action:'block', id:blockId
    }
}
