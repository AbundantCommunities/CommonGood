package commongood

class QuestionController {

    def domainAuthorizationService
    def authorizationService

    /**
     * Prepare for the page that displays an interview form's questions, so user
     * can enter the answers.
     */
    def index( ) {
        def familyId = Long.parseLong( params.familyId )
        authorizationService.family( familyId, session )
        Family family = Family.get( familyId )
        println "Preparing answer form for ${family}"
        println "Interviewed = ${family.interviewed}"

        Person interviewer // Block Connector
        authorizationService.family( familyId, session )

        if( !family.interviewed ) {
            // Having problems forcing default values for new family rows :-(
            family.participateInInterview = Boolean.TRUE
            family.permissionToContact = Boolean.TRUE
        }

        List members = Person.where{ family.id == familyId }.list( sort:'orderWithinFamily', order:'asc' )
        members = members.collect{
            [ id:it.id, name:it.fullName ]
        }

        // We will pass a list of the relevant BCs and NCs to the browser so
        // that the user can pick the interviewer.
        Long neighbourhoodId = family.address.block.neighbourhood.id
        Long blockId = family.address.block.id
        def possibleInterviewers = domainAuthorizationService.getPossibleInterviewers( neighbourhoodId, blockId, family.interviewer?.id )

        def questions = Question.findAll('from Question where neighbourhood.id=? order by orderWithinQuestionnaire, id', [family.address.block.neighbourhood.id])

        Map result =
            [
            familyId: familyId, // Support navigating back to the family
            familyName: family.name,

            // TODO Is it bad practice to pass attached domain objects to a GSP?
            questions: questions,
            members: members,

            interviewed:family.interviewed,
            interviewDate:family.interviewDate,
            possibleInterviewers:possibleInterviewers,
            participateInInterview:family.participateInInterview,
            permissionToContact:family.permissionToContact,
            ]
        result
    }
}
