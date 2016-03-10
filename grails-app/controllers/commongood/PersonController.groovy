package commongood

class PersonController {
    static allowedMethods = [save:'POST', setBlockConnector:'POST']
    def authorizationService

    def save() {
        Person person
        def newPerson
        if( 'id' in params ) {
            def personId = Long.valueOf( params.id )
            authorizationService.person( personId, session )
            log.info "${session.user.getFullName()} requests save changes to person/${personId}"
            person = Person.get( personId )
            newPerson = false
        } else {
            // The request is to create a new person
            def familyId = Long.valueOf( params.familyId )
            authorizationService.family( familyId, session )
            log.info "${session.user.getFullName()} requests add person to family/${familyId}"
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

        if( params.orderWithinFamily ) {
            person.orderWithinFamily = params.int('orderWithinFamily')
        } else {
            // Find the largest value of orderWithinFamily and go from there...
            def query = Person.where {
                family.id == person.family.id
            }.projections {
                max('orderWithinFamily')
            }
            def lastOrder = query.find() as Integer
            lastOrder = lastOrder ?: 0
            person.orderWithinFamily = lastOrder + 100
        }

        // TODO Replace failOnError with logic
        person.save( flush:true, failOnError: true )
        if( newPerson ) {
            redirect controller:'navigate', action:'family', id:person.family.id
        } else {
            redirect controller:'navigate', action:'familymember', id:person.id
        }
    }

    def setBlockConnector( ) {
        Long id = Long.parseLong( params.id )
        log.info "${session.user.getFullName()} requests person/${id} be a BC"
        Person person = Person.get( id )
        def blockId = person.family.address.block.id
        authorizationService.block( blockId, session )

        // The person becomes a BC for his block
        DomainAuthorization da = new DomainAuthorization( )
        da.person = person
        da.domainCode = DomainAuthorization.BLOCK
        da.domainKey = blockId as Integer
        da.orderWithinDomain = 100
        da.save( flush:true, failOnError: true )
        redirect controller:'navigate', action:'block', id:blockId
    }
}
