package commongood

class PersonController {
    static allowedMethods = [index:'POST']

    def save() {
        if( 'id' in params ) {
            def personId = Long.valueOf( params.id )
            println "Request to CHANGE person ${personId}"
            def person = Person.get( personId )
        } else {
            // The request is to create a new person
            def familyId = Long.valueOf( params.familyId )
            println "Request to ADD a person to family ${familyId}"
            Person person = new Person( )
            person.family = Family.get( familyId )
        }

        person.firstNames = params.firstNames
        person.lastName = params.lastName
        person.birthYear = params.birthYear
        person.emailAddress = params.emailAddress
        person.phoneNumber = params.phoneNumber
        person.orderWithinFamily = params.orderWithinFamily
        // TODO Test: family.save(failOnError: true)
        person.save( flush:true )
        forward controller:'navigate', action:'familymember', id:personId
    }
}
