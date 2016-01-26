package commongood

class PersonController {
    static allowedMethods = [save:'POST', setBlockConnector:'POST']

    def save() {
        Person person
        def newPerson
        if( 'id' in params ) {
            def personId = Long.valueOf( params.id )
            println "Request to CHANGE person ${personId}"
            person = Person.get( personId )
            newPerson = false
        } else {
            // The request is to create a new person
            def familyId = Long.valueOf( params.familyId )
            println "Request to ADD a person to family ${familyId}"
            person = new Person( )
            person.family = Family.get( familyId )
            newPerson = true
        }

        person.firstNames = params.firstNames
        person.lastName = params.lastName
        person.birthYear = Integer.valueOf( params.birthYear?:'0' )
        person.emailAddress = params.emailAddress
        person.phoneNumber = params.phoneNumber
        person.note = params.note
        person.orderWithinFamily = Integer.valueOf( params.orderWithinFamily ?: '100' )

        // TODO Replace failOnError with logic
        person.save( flush:true, failOnError: true )
        if( newPerson ) {
            forward controller:'navigate', action:'family', id:person.family.id
        } else {
            forward controller:'navigate', action:'familymember', id:person.id
        }
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
