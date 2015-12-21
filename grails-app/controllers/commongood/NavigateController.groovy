package commongood

/*
We handle GET requests that navigate to some part of our data's "natural hierarchy".
*/
class NavigateController {

    def application( ) {
        List hoods = Neighbourhood.list( sort:'name', order:'asc')
        hoods = hoods.collect{
            [ id:it.id, name:it.name]
        }
        Map result =
            [
            navContext: [ ],

            navSelection: [ levelInHierarchy: 'Application', description:'Installation Name Goes Here' ],

            navChildren:
                [
                childType: 'Neighbourhood',
                children: hoods
                ]
            ]
        println 'Navigate to application'
        result
    }

    def neighbourhood( ) {
        Integer hoodId = Integer.valueOf( params.id )
        Neighbourhood theHood = Neighbourhood.where{ id == hoodId }.get( )
        List blocks = Block.where{ neighbourhood.id == hoodId }.list( sort:'orderWithinNeighbourhood', order:'asc' )
        blocks = blocks.collect{
            [ id:it.id, name:it.displayName]
        }
        Map result =
            [
            navContext: [ ],

            navSelection: [ levelInHierarchy: 'Neighbourhood', description:theHood.name ],

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
                    [id: theBlock.neighbourhood.id, level: 'Neighbourhood', description: theBlock.neighbourhood.name]
                ],

            navSelection: [ levelInHierarchy: 'Block', description:theBlock.displayName ],

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
        List families = Family.where{ address.id == addressId }.list( )
        families = families.collect{
            [ id:it.id, name:it.name]
        }
        Map result =
            [
            navContext:
                [
                    [id: theAddress.block.neighbourhood.id, level: 'Neighbourhood', description: theAddress.block.neighbourhood.name],
                    [id: theAddress.block.id, level: 'Block', description: theAddress.block.code]
                ],

            navSelection: [ levelInHierarchy: 'Address', description:theAddress.text ],

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
        Integer familyId = Integer.valueOf( params.id )
        Family theFamily = Family.where{ id == familyId }.get( )
        List members = Person.where{ family.id == familyId }.list( sort:'firstNames', order:'asc' )
        members = members.collect{
            [ id:it.id, name:(it.firstNames+' '+it.lastName) ]
        }
        Map result =
            [
            navContext:
                [
                    [id: theFamily.address.block.neighbourhood.id, level: 'Neighbourhood', description: theFamily.address.block.neighbourhood.name],
                    [id: theFamily.address.block.id, level: 'Block', description: theFamily.address.block.code],
                    [id: theFamily.address.id, level: 'Address', description: theFamily.address.text]
                ],

            navSelection: [ levelInHierarchy: 'Family', description: theFamily.name, id: theFamily.id],

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
        Integer memberId = Integer.valueOf( params.id )
        Person theMember = Person.where{ id == memberId }.get( )
        List answers = Answer.where{ person.id == memberId }.list( sort:'question.id', order:'asc' )
        // TODO Join answers to questions to get orderWithinQuestionnaire
        // ... allows us to refactor the 1L, 2L, etc map
        def questions = [ 1L:'1. Great', 2L:'2. Better', 3L:'3. Activities', 4L:'4. Interests', 5L:'5. Skill', 6L:'6. Life' ]
        def groupedAnswers = [:]
        answers.each {
            def qCode = it.question.id
            def soFar = groupedAnswers[ qCode ]
            if( soFar ) {
                groupedAnswers[ qCode ] += ', ' + it.text
            } else {
                groupedAnswers[ qCode ] = questions[qCode] + ': ' + it.text
            }
        }
        def children = [ ]
        groupedAnswers = groupedAnswers.each { key, value ->
            children << [ id:key, name:value ]
        }
        Map result =
        [
            navContext:
            [
                [id: theMember.family.address.block.neighbourhood.id, level: 'Neighbourhood', description: theMember.family.address.block.neighbourhood.name],
                [id: theMember.family.address.block.id, level: 'Block', description: theMember.family.address.block.code],
                [id: theMember.family.address.id, level: 'Address', description: theMember.family.address.text],
                [id: theMember.family.id, level: 'Family', description: theMember.family.name]
            ],

            navSelection: [ levelInHierarchy: 'Family Member', description:(theMember.firstNames+' '+theMember.lastName) ],

            navChildren:
            [
            childType: 'Question',
            children: children
            ]
        ]
        println "Navigate to family member ${memberId}"
        result
    }
}
