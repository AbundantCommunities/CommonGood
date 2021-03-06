package commongood

import grails.transaction.Transactional

@Transactional
class PersonService {

    // Update an existing Person.
    // Return the Person iff it was updated successfully
    // Return null if we detected a duplicate email address
    def update( Integer personId, params ) {
        Person person = Person.get( personId )

        if( person.version != params.int('version') ) {
            throw new Exception('Stale person')
        }

        if( person.emailAddress != params.emailAddress ) {
            // The new address must not be in use by someone else
            // (our UI should've prevented this)
            if( emailExists(params.emailAddress) ) {
                return null
            }
        }
        person.firstNames = params.firstNames
        person.lastName = params.lastName
        person.birthYear = Integer.valueOf( params.birthYear?:'0' )
        person.birthYearIsEstimated = ('birthYearIsEstimated' in params)
        person.emailAddress = params.emailAddress
        person.phoneNumber = params.phoneNumber
        person.note = params.note

        // TODO Replace failOnError with logic
        person.save( flush:true, failOnError: true )
        return person
    }

    Person emailExists( String emAddr ) {
        if( emAddr ) {
            return Person.findByEmailAddress( emAddr )
        } else {
            return null
        }
    }

    // Insert a new Person to the specified Family.
    // Return the Person iff it was created successfully
    // Return null if we detected a duplicate email address
    def insert( Integer familyId, params ) {

        if( emailExists(params.emailAddress) ) {
            // Our UI should've prevented this
            return null
        }
        Person person = new Person( params )
        person.family = Family.get( familyId )

        person.firstNames = params.firstNames
        person.lastName = params.lastName
        person.birthYear = Integer.valueOf( params.birthYear?:'0' )
        person.birthYearIsEstimated = ('birthYearIsEstimated' in params)
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
        return person
    }
}
