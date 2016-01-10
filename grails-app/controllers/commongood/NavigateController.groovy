package commongood

/*
We handle GET requests that navigate to some part of our data's "natural hierarchy".
*/
class NavigateController {

    // Automagically becomes an instance of DomainAuthorizationService:
    def domainAuthorizationService
    
    def installation( ) {
        ThisInstallation thisInstallation = ThisInstallation.get( )
        List hoods = Neighbourhood.list( sort:'name', order:'asc')
        hoods = hoods.collect{
            [ id:it.id, name:it.name]
        }
        Map result =
            [
            navContext: [ ],

            navSelection: [ levelInHierarchy:'Installation', description:thisInstallation.name,
                            configured: thisInstallation.configured ],

            navChildren:
                [
                childType: 'Neighbourhood',
                children: hoods
                ]
            ]
        println 'Navigate to application'
        render "This installation of CommonGood is: ${thisInstallation.name}"
    }

    def neighbourhood( ) {
        Integer hoodId = Integer.valueOf( params.id )
        Neighbourhood theHood = Neighbourhood.where{ id == hoodId }.get( )
        List blocks = Block.where{ neighbourhood.id == hoodId }.list( sort:'orderWithinNeighbourhood', order:'asc' )
        blocks = blocks.collect{
            [ id:it.id, name:it.displayName ]
        }
        Map result =
            [
            navContext: [ ],

            navSelection: [ levelInHierarchy:'Neighbourhood', id:hoodId, description:theHood.name ],

            navChildren:
                [
                childType: 'Block',
                children: blocks
                ]
            ]
        println "Navigate to neighbourhood ${hoodId} ${theHood.name}"
        result
    }

    def block( ) {
        Integer blockId = Integer.valueOf( params.id )
        Block theBlock = Block.where{ id == blockId }.get( )
        List addresses = Address.where{ block.id == blockId }.list( sort:'orderWithinBlock', order:'asc' )
        addresses = addresses.collect{
            [ id:it.id, name:it.text]
        }
        Map result =
            [
            navContext:
                [
                    [level:'Neighbourhood', id: theBlock.neighbourhood.id, description: theBlock.neighbourhood.name]
                ],

            navSelection: [ levelInHierarchy:'Block', id:blockId, description:theBlock.description,
                            code:theBlock.code, orderWithinNeighbourhood:theBlock.orderWithinNeighbourhood ],

            navChildren:
                [
                childType: 'Address',
                children: addresses
                ]
            ]
        println "Navigate to block ${blockId}"
        result
    }

    def address( ) {
        Integer addressId = Integer.valueOf( params.id )
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
        println "Navigate to address ${addressId}"
        result
    }

    def family( ) {
        Person interviewer // Block Connector
        Integer familyId = Integer.valueOf( params.id )
        Family theFamily = Family.where{ id == familyId }.get( )
        List members = Person.where{ family.id == familyId }.list( sort:'orderWithinFamily', order:'asc' )
        members = members.collect{
            [ id:it.id, name:it.fullName ]
        }

        // In order to allow "edit a family" to change the interviewer,
        // we will pass a list of the relevant BCs and NCs to the browser.
        Long neighbourhoodId = theFamily.address.block.neighbourhood.id
        Long blockId = theFamily.address.block.id
        def possibleInterviewers = domainAuthorizationService.getPossibleInterviewers( neighbourhoodId, blockId, theFamily.interviewer.id )

        def questions = Question.findAll('from Question where neighbourhood.id=? order by orderWithinQuestionnaire, id', [theFamily.address.block.neighbourhood.id])

        Map result =
            [
            navContext:
                [
                    [id: theFamily.address.block.neighbourhood.id, level: 'Neighbourhood', description: theFamily.address.block.neighbourhood.name],
                    [id: theFamily.address.block.id, level: 'Block', description: theFamily.address.block.displayName],
                    [id: theFamily.address.id, level: 'Address', description: theFamily.address.text]
                ],

            navSelection:[ levelInHierarchy: 'Family', id:familyId, description: theFamily.name, note:theFamily.note,
                            interviewDate:theFamily.interviewDate,
                            orderWithinAddress:theFamily.orderWithinAddress,
                            participateInInterview:theFamily.participateInInterview,
                            permissionToContact:theFamily.permissionToContact,
                            possibleInterviewers:possibleInterviewers,
                            questions: questions ],

            navChildren:
                [
                childType: 'Familymember',
                children: members
                ]
            ]
        println "Navigate to family ${familyId}"
        result
    }

    // Lower case M because of the way our GSP constructs navigation URLs
    def familymember( ) {
        Long memberId = Long.valueOf( params.id )

        /* The answers look like:
//        [ [commongood.Answer : 54, commongood.Person : 7, commongood.Question : 12],
            [commongood.Answer : 55, commongood.Person : 7, commongood.Question : 13],
            [commongood.Answer : 56, commongood.Person : 7, commongood.Question : 14] ]
*/
        def answers = Answer.findAll('from Answer a join a.person p join a.question q where p.id=? order by q.orderWithinQuestionnaire, a.id', [memberId])
        Person theMember
        if( answers.size() == 0 ) {
            theMember = Person.where{ id == memberId }.get( )
        } else {
            theMember = answers[0][1]
        }

        // FIXME Grouping of answers for a member works only for Standard 6 questions
        def groupedAnswers = [ '1':'1. Great: ', '2':'2. Better: ', '3':'3. Activities: ', '4':'4. Interests: ', '5':'5. Skill: ', '6':'6. Life: ' ]
        answers.each {
            Answer answer = it[0]
            Question question = it[2]

            def soFar = groupedAnswers[ question.code ]
            if( soFar.endsWith(': ') ) {
                groupedAnswers[ question.code ] += answer.text
            } else {
                groupedAnswers[ question.code ] += ', ' + answer.text
            }
        }

        def children = [ ]
        groupedAnswers = groupedAnswers.each { key, value ->
            if( value.endsWith(': ') ) {
                value += '?'
            }
            children << [ id:key, name:value ]
        }

        Map result =
        [
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

            navChildren:
            [
            childType: 'Question',
            children: children
            ]
        ]
        println "Navigate to family member ${memberId}"
        result
    }

    def question( ) {
        Integer questionId = Integer.valueOf( params.id )
        render "You asked to navigate to question id ${questionId} but that feature is not implemented!"
/*
        Question theQuestion = Question.where{ id == questionId }.get( )
        List answers = Answer.where{ neighbourhood.id == hoodId }.list( sort:'orderWithinNeighbourhood', order:'asc' )
        blocks = blocks.collect{
            [ id:it.id, name:it.displayName]
        }
        Map result =
            [
            navContext: [ ],

            navSelection: [ levelInHierarchy:'Neighbourhood', id:hoodId, description:theHood.name ],

            navChildren:
                [
                childType: 'Block',
                children: blocks
                ]
            ]
        println "Navigate to neighbourhood ${hoodId} ${theHood.name}"
        result
*/
    }
}
