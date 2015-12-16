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
            [ id:it.id, name:it.code]
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
        List locations = Location.where{ block.id == blockId }.list( sort:'orderWithinBlock', order:'asc' )
        locations = locations.collect{
            [ id:it.id, name:it.officialAddress]
        }
        Map result =
            [
            navContext:
                [
                    [id: theBlock.neighbourhood.id, level: 'Neighbourhood', description: theBlock.neighbourhood.name]
                ],

            navSelection: [ levelInHierarchy: 'Block', description:theBlock.code ],

            navChildren:
                [
                childType: 'Location',
                children: locations
                ]
            ]
        println "Navigate to block ${blockId}"
        result
    }

    def address( ) {
        Integer locationId = Integer.valueOf( params.id )
        Location theLocation = Location.where{ id == locationId }.get( )
        List families = Family.where{ location.id == locationId }.list( )
        families = families.collect{
            [ id:it.id, name:it.familyName]
        }
        Map result =
            [
            navContext:
                [
                    [id: theLocation.block.neighbourhood.id, level: 'Neighbourhood', description: theLocation.block.neighbourhood.name],
                    [id: theLocation.block.id, level: 'Block', description: theLocation.block.code]
                ],

            navSelection: [ levelInHierarchy: 'Location', description:theLocation.officialAddress ],

            navChildren:
                [
                childType: 'Family',
                children: families
                ]
            ]
        println "Navigate to address ${locationId}"
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
                    [id: theFamily.location.block.neighbourhood.id, level: 'Neighbourhood', description: theFamily.location.block.neighbourhood.name],
                    [id: theFamily.location.block.id, level: 'Block', description: theFamily.location.block.code],
                    [id: theFamily.location.id, level: 'Location', description: theFamily.location.officialAddress]
                ],

            navSelection: [ levelInHierarchy: 'Family', description:theFamily.familyName ],

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
        List answers = Answer.where{ person.id == memberId }.list( sort:'questionCode', order:'asc' )
        def questions = [ 1:'1. Great', 2:'2. Better', 3:'3. Activities', 4:'4. Interests', 5:'5. Skill', 6:'6. Life' ]
        def groupedAnswers = [:]
        answers.each {
            def qCode = it.questionCode
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
                [id: theMember.family.location.block.neighbourhood.id, level: 'Neighbourhood', description: theMember.family.location.block.neighbourhood.name],
                [id: theMember.family.location.block.id, level: 'Block', description: theMember.family.location.block.code],
                [id: theMember.family.location.id, level: 'Location', description: theMember.family.location.officialAddress],
                [id: theMember.family.id, level: 'Family', description: theMember.family.familyName]
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
