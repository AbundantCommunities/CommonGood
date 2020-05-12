package commongood

import org.abundantcommunityinitiative.commongood.handy.LogAid

/*
We handle GET requests that navigate to some part of our data's "natural hierarchy".
*/
class NavigateController {

    // Automagically become instances of the respective service:
    def domainAuthorizationService
    def authorizationService
    def blockService
    def gisService

    // Allows a GSP to have a link back to the last place to which the user
    // navigated. Example: remember( 'family', familyId )
    def remember( lastNavigationLevel, lastNavigationId ) {
        session.lastNavigationLevel = lastNavigationLevel
        session.lastNavigationId = lastNavigationId
    }

    def neighbourhood( ) {
        Integer hoodId = Integer.valueOf( params.id )
        authorizationService.neighbourhoodRead( hoodId, session )
        log.info "${LogAid.who(session)} to neighbourhood/${hoodId}"
        Neighbourhood theHood = Neighbourhood.get( hoodId )
        List questions = Question.where{ neighbourhood.id == hoodId }.list( sort:'orderWithinQuestionnaire', order:'asc' )
        List blocks = blockService.getForNeighbourhood( session.authorized )
        Map result =
            [
            authorized: session.authorized,
            anonymousRequests: AnonymousRequest.countByNeighbourhood(theHood),
            navContext: [ ],

            navSelection: [ levelInHierarchy:'Neighbourhood', id:hoodId,
                                description:theHood.name, questions: questions, boundary:gisService.getBoundaryCoordinates(theHood) ],

            navChildren:
                [
                childType: 'Block',
                children: blocks
                ]
            ]
        remember( 'neighbourhood', hoodId )
        result
    }

    def block( ) {
        def blockId = Long.valueOf( params.id )
        authorizationService.blockRead( blockId, session )
        log.info "${LogAid.who(session)} to block/${blockId}"
        Block theBlock = Block.get( blockId )
        def blockConnectors = domainAuthorizationService.getBlockConnectors( blockId )

        Map result =
            [
            authorized: session.authorized,
            anonymousRequests: AnonymousRequest.countByNeighbourhood(theBlock.neighbourhood),
            navContext:
                [
                    [level:'Neighbourhood', id: theBlock.neighbourhood.id, description: theBlock.neighbourhood.name]
                ],

            navSelection: [ levelInHierarchy:'Block', block:theBlock, blockConnectors:blockConnectors, boundary:gisService.getBoundaryCoordinates(theBlock) ],

            navChildren:
                [
                childType: 'Address',
                children: blockService.getAddresses( blockId )
                ]
            ]
        remember( 'block', blockId )
        result
    }

    def address( ) {
        Integer addressId = Integer.valueOf( params.id )
        authorizationService.addressRead( addressId, session )
        log.info "${LogAid.who(session)} to address/${addressId}"
        Address theAddress = Address.where{ id == addressId }.get( )
        List families = Family.where{ address.id == addressId }.list( sort:'orderWithinAddress', order:'asc' )
        families = families.collect{
            [ id:it.id, name:it.name]
        }

        // In order to allow "add a family" to select an interviewer,
        // we will pass a list of the relevant BCs and NCs to the browser.
        Long neighbourhoodId = theAddress.block.neighbourhood.id
        Long blockId = theAddress.block.id
        def possibleInterviewers = domainAuthorizationService.getPossibleInterviewers( neighbourhoodId, blockId )
        
        Map result =
            [
            authorized: session.authorized,
            anonymousRequests: AnonymousRequest.countByNeighbourhood(theAddress.block.neighbourhood),
            navContext:
                [
                    [id: theAddress.block.neighbourhood.id, level: 'Neighbourhood', description: theAddress.block.neighbourhood.name],
                    [id: theAddress.block.id, level: 'Block', description: theAddress.block.displayName]
                ],

            navSelection: [ levelInHierarchy:'Address', id:addressId, description:theAddress.text, note:theAddress.note,
                            orderWithinBlock:theAddress.orderWithinBlock, possibleInterviewers:possibleInterviewers,
                            boundary:gisService.getBoundaryCoordinates( theAddress.block ), latitude:theAddress.latitude, longitude:theAddress.longitude,
                            version:theAddress.version ],

            navChildren:
                [
                childType: 'Family',
                children: families
                ]
            ]
        remember( 'address', addressId )
        result
    }

    def family( ) {
        Person interviewer // Block Connector
        Integer familyId = Integer.valueOf( params.id )
        authorizationService.familyRead( familyId, session )
        log.info "${LogAid.who(session)} to family/${familyId}"
        Family theFamily = Family.get( familyId )

        List members = Person.where{ family.id == familyId }.list( sort:'orderWithinFamily', order:'asc' )
        members = members.collect{
            [ id:it.id, name:it.fullName ]
        }

        // In order to allow "edit a family" to change the interviewer,
        // we will pass a list of the relevant BCs and NCs to the browser.
        Long neighbourhoodId = theFamily.address.block.neighbourhood.id
        Long blockId = theFamily.address.block.id
        def possibleInterviewers = domainAuthorizationService.getPossibleInterviewers( neighbourhoodId, blockId, theFamily.interviewer?.id )

        Map result =
            [
            authorized: session.authorized,
            anonymousRequests: AnonymousRequest.countByNeighbourhood(theFamily.address.block.neighbourhood),
            navContext:
                [
                    [id: theFamily.address.block.neighbourhood.id, level: 'Neighbourhood', description: theFamily.address.block.neighbourhood.name],
                    [id: theFamily.address.block.id, level: 'Block', description: theFamily.address.block.displayName],
                    [id: theFamily.address.id, level: 'Address', description: theFamily.address.text]
                ],

            navSelection:[ levelInHierarchy: 'Family', id:familyId, description: theFamily.name, note:theFamily.note,
                            interviewDate:theFamily.interviewDate, interviewed:theFamily.interviewed,
                            orderWithinAddress:theFamily.orderWithinAddress,
                            participateInInterview:theFamily.participateInInterview,
                            permissionToContact:theFamily.permissionToContact,
                            possibleInterviewers:possibleInterviewers,
                         ],

            navChildren:
                [
                childType: 'Familymember',
                children: members
                ]
            ]
        remember( 'family', familyId )
        result
    }

    // Lower case M because of the way our GSP constructs navigation URLs
    def familymember( ) {
        Long memberId = Long.valueOf( params.id )
        authorizationService.personRead( memberId, session )
        log.info "${LogAid.who(session)} to familyMember/${memberId}"

        /* The result of the following query looks like:
//        [ [commongood.Answer : 54, commongood.Person : 7, commongood.Question : 12],
            [commongood.Answer : 55, commongood.Person : 7, commongood.Question : 14],
            [commongood.Answer : 56, commongood.Person : 7, commongood.Question : 14] ]
*/
        def answers = Answer.findAll('from Answer a join a.person p join a.question q where p.id=? order by q.orderWithinQuestionnaire, a.id', [memberId])
        Person theMember
        if( answers.size() == 0 ) {
            theMember = Person.get( memberId )
        } else {
            theMember = answers[0][1]
        }

        // Questions & Answers
        def qna = [ ]

        // Commented out condition below for the case where a family that has been interviewed has a family member with answers,
        // and that family member is moved to a family that has not been interviewed. If condition is left in, answers for
        // the moved family member would disappear.

        //if( theMember.family.getInterviewed() ) {
            def previousQuestion = null
            def theseAnswers = [ ]
            answers.each {
                Answer answer = it[0]
                Question question = it[2]
                if( question != previousQuestion ) {
                    if( previousQuestion ) {
                        qna << [ question:previousQuestion.getShortHeader( ), answers:theseAnswers ]
                    }
                    previousQuestion = question
                    theseAnswers = [ ]
                }
                theseAnswers << [id:answer.id, text:answer.text]
            }
            if( theseAnswers ) {
                // Flush the last set of answers:
                qna << [ question:previousQuestion.getShortHeader( ), answers:theseAnswers ]
            }
        //}

        Map result =
        [
            authorized: session.authorized,
            anonymousRequests: AnonymousRequest.countByNeighbourhood(theMember.family.address.block.neighbourhood),
            navContext:
            [
                [id: theMember.family.address.block.neighbourhood.id, level: 'Neighbourhood', description: theMember.family.address.block.neighbourhood.name],
                [id: theMember.family.address.block.id, level: 'Block', description: theMember.family.address.block.displayName],
                [id: theMember.family.address.id, level: 'Address', description: theMember.family.address.text],
                [id: theMember.family.id, level: 'Family', description: theMember.family.name]
            ],

            navSelection:[ levelInHierarchy: 'Family Member', id:memberId, description:theMember.fullName,
                            firstNames:theMember.firstNames, lastName:theMember.lastName,
                            birthYear:theMember.birthYear, birthYearIsEstimated: theMember.birthYearIsEstimated,
                            emailAddress:theMember.emailAddress, phoneNumber:theMember.phoneNumber,
                            orderWithinFamily:theMember.orderWithinFamily, note:theMember.note, version:theMember.version ],
            
            questionsAndAnswers: qna
        ]
        remember( 'familymember', memberId )
        result
    }
}
