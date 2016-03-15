package commongood

/*
We handle GET requests that navigate to some part of our data's "natural hierarchy".
*/
class NavigateController {

    // Automagically become instances of the respective service:
    def domainAuthorizationService
    def authorizationService
    def blockService

    def remember( lastNavigationLevel, lastNavigationId ) {
        session.lastNavigationLevel = lastNavigationLevel
        session.lastNavigationId = lastNavigationId
    }

    def neighbourhood( ) {
        Integer hoodId = Integer.valueOf( params.id )
        authorizationService.neighbourhood( hoodId, session )
        log.info "${session.user.getLogName()} to neighbourhood/${hoodId}"
        Neighbourhood theHood = Neighbourhood.where{ id == hoodId }.get( )
        List questions = Question.where{ neighbourhood.id == hoodId }.list( sort:'orderWithinQuestionnaire', order:'asc' )
        List blocks = blockService.getForNeighbourhood( session.authorized )
        Map result =
            [
            authorized: session.authorized,
            navContext: [ ],

            navSelection: [ levelInHierarchy:'Neighbourhood', id:hoodId,
                                description:theHood.name, questions: questions ],

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
        authorizationService.block( blockId, session )
        log.info "${session.user.getLogName()} to block/${blockId}"
        Block theBlock = Block.where{ id == blockId }.get( )
        def blockConnectors = domainAuthorizationService.getBlockConnectors( blockId )
        List addresses = Address.where{ block.id == blockId }.list( sort:'orderWithinBlock', order:'asc' )
        addresses = addresses.collect{
            [ id:it.id, name:it.text]
        }
        Map result =
            [
            authorized: session.authorized,
            navContext:
                [
                    [level:'Neighbourhood', id: theBlock.neighbourhood.id, description: theBlock.neighbourhood.name]
                ],

            navSelection: [ levelInHierarchy:'Block', id:blockId, description:theBlock.description,
                            code:theBlock.code, orderWithinNeighbourhood:theBlock.orderWithinNeighbourhood,
                            blockConnectors:blockConnectors ],

            navChildren:
                [
                childType: 'Address',
                children: addresses
                ]
            ]
        remember( 'block', blockId )
        result
    }

    def address( ) {
        Integer addressId = Integer.valueOf( params.id )
        authorizationService.address( addressId, session )
        log.info "${session.user.getLogName()} to address/${addressId}"
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
            navContext:
                [
                    [id: theAddress.block.neighbourhood.id, level: 'Neighbourhood', description: theAddress.block.neighbourhood.name],
                    [id: theAddress.block.id, level: 'Block', description: theAddress.block.displayName]
                ],

            navSelection: [ levelInHierarchy:'Address', id:addressId, description:theAddress.text, note:theAddress.note,
                            orderWithinBlock:theAddress.orderWithinBlock, possibleInterviewers:possibleInterviewers ],

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
        authorizationService.family( familyId, session )
        log.info "${session.user.getLogName()} to family/${familyId}"
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
        authorizationService.person( memberId, session )
        log.info "${session.user.getLogName()} to familyMember/${memberId}"

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
        if( theMember.family.getInterviewed() ) {
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
        }

        Map result =
        [
            authorized: session.authorized,
            navContext:
            [
                [id: theMember.family.address.block.neighbourhood.id, level: 'Neighbourhood', description: theMember.family.address.block.neighbourhood.name],
                [id: theMember.family.address.block.id, level: 'Block', description: theMember.family.address.block.displayName],
                [id: theMember.family.address.id, level: 'Address', description: theMember.family.address.text],
                [id: theMember.family.id, level: 'Family', description: theMember.family.name]
            ],

            navSelection:[ levelInHierarchy: 'Family Member', id:memberId, description:theMember.fullName,
                            firstNames:theMember.firstNames, lastName:theMember.lastName,
                            birthYear:theMember.birthYear, emailAddress:theMember.emailAddress,
                            phoneNumber:theMember.phoneNumber, orderWithinFamily:theMember.orderWithinFamily,
                            note:theMember.note ],
            
            questionsAndAnswers: qna
        ]
        remember( 'familymember', memberId )
        result
    }
}
