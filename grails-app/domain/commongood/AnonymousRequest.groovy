package commongood

/**
 * Intent is that a neighbourhood's website hosts a form into which a resident
 * enters a request like "I want to make garden with my neighbours".
 */
class AnonymousRequest {
    String residentName
    String homeAddress
    String emailAddress
    String phoneNumber
    String comment

    Neighbourhood neighbourhood
    String ipAddress
    String requestContext // For the hosting website to say what page generated request
    String requestReference // For host to add specificity to requestContext

    Date dateCreated

    static constraints = {
        comment( maxSize:2000 )
    }
}
