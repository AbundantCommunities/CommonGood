package commongood

/*
We handle all GET requests to navigate to some part of our data's "natural hierarchy"
*/
class NavigateController {

    def application( ) {
        List hoods = Neighbourhood.list( sort:'name', order:'asc')
        hoods = hoods.collect{
            it.name
        }
        println "Navigate to top of application instance ${hoods}"
        [result:
            [
                navContext: [navPath: '(list of map {levelName (string), levelValue (string)}, navBackLevel (string), navBackId (long) }'],
                navSelection: 'Common Good Running Here!',
                navChildren: hoods
            ]
        ]
    }

    def neighbourhood( ) {
        Integer hoodId = Integer.valueOf( params.id )
        Neighbourhood theHood = Neighbourhood.where{ id == hoodId }.get( )
        List blocks = Block.where{ neighbourhood.id == hoodId }.list( sort:'orderWithinNeighbourhood', order:'asc' )
        blocks = blocks.collect{
            it.code
        }
        println "Navigate to neighbourhood ${hoodId} ${blocks}"
        Map result =
            [
            navContext:
                [
                navPath:
                    [
                    [levelName:'fruit',levelValue:'cherry'],
                    [levelName:'dog',levelValue:'labrador'],
                    [levelName:'cloud',levelValue:'cumulus']
                    ],
                navBackLevel: 'cloud :)',
                navBackId: 'cumulus'
                ],

            navSelection: "Neighbourhood ${hoodId}, ${theHood.name}",

            navChildren:
                [
                childType: 'Location',
                children:
                    [
                        [
                        id: 1,
                        name: 'bobby'
                        ],
                        [
                        id: 2,
                        name: 'sally'
                        ]
                    ]
                ]
            ]
        render(view: "organize", model: result)
    }

    def block( ) {
        Integer id = Integer.valueOf( params.id )
        List locations = Location.where{ block.id == id }.list( sort:'orderWithinBlock', order:'asc' )
        render "Navigate to block ${id} ${locations}"
    }

    def location( ) {
        Integer id = Integer.valueOf( params.id )
        List families = Family.where{ location.id == id }.list( )
        render "Navigate to location ${id} ${families}"
    }

    def family( ) {
        Integer id = Integer.valueOf( params.id )
        List members = Person.where{ family.id == id }.list( )
        render "Navigate to family ${id} ${members}"
    }

    def familyMember( ) {
        Integer id = Integer.valueOf( params.id )
        List answers = Response.where{ person.id == id }.list( )
        render "Navigate to familyMember ${id} ${answers}"
    }
}
