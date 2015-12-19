package commongood

class SaveFamilyMemberController {
//  static allowedMethods = [index:'POST']

// test change existing
// http://localhost:8080/CommonGood/saveFamilyMember/index/42?firstNames=Jonah+James&lastName=Johnson&emailAddress=jjj@jfamily.ca&birthYear=1999&orderWithinFamily=1234
//
// test create new
// http://localhost:8080/CommonGood/saveFamilyMember/index?firstNames=Jonah+James&lastName=Johnson&emailAddress=jjj@jfamily.ca&birthYear=1999&orderWithinFamily=1234

    def index() {
        String debug
        if( 'id' in params ) {
            // The request wants us to change an existing family member (a person)
            def personId = Integer.valueOf( params.id )
            debug = "CHANGE member ${personId}"
        } else {
            // The request is to create a new family member (a person)
            debug = "CREATE member"
        }

        def firstNames = params.firstNames
        def lastName = params.lastName
        def phoneNumber = params.phoneNumber
        def emailAddress = params.emailAddress
        def birthYear = params.birthYear
        def orderWithinFamily = params.orderWithinFamily

        render debug + " firstNames=${firstNames} lastName=${lastName} phone=${phoneNumber} " +
                "email=${emailAddress} year=${birthYear} order=${orderWithinFamily}"
    }
}
