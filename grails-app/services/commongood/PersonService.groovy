package commongood

import grails.transaction.Transactional

@Transactional
class PersonService {

    // Update an existing Person.
    def update( Integer personId, params ) {
        Person person = Person.get( personId )

        if( person.version != params.int('version') ) {
            throw new Exception('Stale person')
        }

        person.firstNames = params.firstNames
        person.lastName = params.lastName
        person.birthYear = Integer.valueOf( params.birthYear?:'0' )
        person.emailAddress = params.emailAddress
        person.phoneNumber = params.phoneNumber
        person.note = params.note
        person.orderWithinFamily = params.int('orderWithinFamily')

        // TODO Replace failOnError with logic
        person.save( flush:true, failOnError: true )
    }

    // Insert a new Person to the specified Family.
    def insert( Integer familyId, params ) {
        Person person = new Person( params )
        person.family = Family.get( familyId )

        person.firstNames = params.firstNames
        person.lastName = params.lastName
        person.birthYear = Integer.valueOf( params.birthYear?:'0' )
        person.emailAddress = params.emailAddress
        person.phoneNumber = params.phoneNumber
        person.note = params.note

        // Find the largest value of orderWithinFamily so we can
        // force the new Person to sort to the end of the Family.
        def query = Person.where {
            family.id == person.family.id
        }.projections {
            max('orderWithinFamily')
        }
        def lastOrder = query.find() as Integer
        lastOrder = lastOrder ?: 0
        person.orderWithinFamily = lastOrder + 100

        // TODO Replace failOnError with logic
        person.save( flush:true, failOnError: true )
    }
}
