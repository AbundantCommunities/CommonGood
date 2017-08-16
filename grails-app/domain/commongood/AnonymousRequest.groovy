package commongood

/**
 * Intent is that a neighbourhood's website hosts a form into which a resident
 * enters a request like "I want to garden with my neighbours".
 */
class AnonymousRequest {
     // These fields could identify anybody or nobody.
     // They COULD identify someone in CG's Person table.
    String residentName
    String homeAddress
    String emailAddress
    String phoneNumber
    String comment

    // We will ensure that this n'hood is in our database
    Neighbourhood neighbourhood

    // Do NOT ASSUME these values will make sense!
    // The submitting machine can stick anything in these 2 fields!
    String requestContext // Ex: "activities" for n'hood's Activities page
    String requestReference // Ex: "birdwatching"

    // This is hard to spoof, but with VPNs and the like, may not be useful.
    String ipAddress

    Date dateCreated

    static constraints = {
        comment( maxSize:2000 )
    }
}
