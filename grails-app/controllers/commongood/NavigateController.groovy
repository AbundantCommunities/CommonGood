package commongood

/*
A bit of stuff. We handle GET requests that navigate to some part of our data's "natural hierarchy".
*/
class NavigateController {

    def application( ) {
        List hoods = Neighbourhood.list( sort:'name', order:'asc')
        hoods = hoods.collect{
            it.name
        }
        println "Navigate to top of application instance ${hoods}"
        Map result =
            [
                navContext: [navPath: '(list of map {levelName (string), levelValue (string)}, navBackLevel (string), navBackId (long) }'],
                navSelection: 'Common Good Running Here!',
                navChildren: hoods
            ]

        render(view: "organize", model: result)
    }

    def neighbourhood( ) {
        Integer hoodId = Integer.valueOf( params.id )
        Neighbourhood theHood = Neighbourhood.where{ id == hoodId }.get( )
        List blocks = Block.where{ neighbourhood.id == hoodId }.list( sort:'orderWithinNeighbourhood', order:'asc' )
        blocks = blocks.collect{
            [ id:it.id, name:it.code]
        }
        println "Navigate to neighbourhood ${hoodId} ${theHood.name}"
        Map result =
            [
            navContext:
                [
                navPath:
                    // There is nothing to show for "what is above the selected object".
                    [:],
                navBackLevel: '',
                navBackId: 0
                ],

            navSelection: theHood.name,

            navChildren:
                [
                childType: 'Block',
                children: blocks
                ]
            ]
        render(view: "organize", model: result)
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
                navPath:
                    [ [levelName: 'Block', levelValue: 12345] ],
                navBackLevel: 'Neighbourhood',
                navBackId: theBlock.neighbourhood.id
                ],

            navSelection: theBlock.code,

            navChildren:
                [
                childType: 'Location',
                children: locations
                ]
            ]
        println "Navigate to block ${blockId}"
        render(view: "organize", model: result)
    }

    def location( ) {
        Integer id = Integer.valueOf( params.id )
        List families = Family.where{ location.id == id }.list( )
        render "Navigate to location ${id} ${families}"
    }

    def family( ) {
        Integer familyId = Integer.valueOf( params.id )
        Block theFamily = Family.where{ id == familyId }.get( )
        List members = Person.where{ family.id == familyId }.list( sort:'firstNames', order:'asc' )
        members = members.collect{
            [ id:it.id, name:(it.firstNames+' '+it.lastName) ]
        }
        println "Navigate to family ${familyId} ${members}"
        render(view: "organize", model: result)
    }

    def familyMember( ) {
        Integer id = Integer.valueOf( params.id )
        List answers = Response.where{ person.id == id }.list( )
        render "Navigate to familyMember ${id} ${answers}"
    }
}
