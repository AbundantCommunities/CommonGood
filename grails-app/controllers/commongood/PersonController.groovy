package commongood

class PersonController {
    static allowedMethods = [save:'POST', search:'GET']

    def search( ) {
        def searchTerm = "%${params.q}%"

        // FIXME These searches examine answers from EVERY hood!
        // Select only answers to that particular question
        def peeps = Person.executeQuery(
            'select p.id, p.firstNames, p.lastName from Person p join p.family f join f.address a \
             where a.text like ? or a.note like ? or f.name like ? or f.note like ? \
             or p.firstNames like ? or p.lastName like ? or p.phoneNumber like ? or p.emailAddress like ? \
             or p.note like ? order by p.firstNames, p.lastName, p.id',
            [ searchTerm ] * 9 )

        [ q:params.q, results:peeps ]
    }

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
}
