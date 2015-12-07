package commongood

import groovy.transform.Canonical

@Canonical
class RBlockConnector {
    String name
    String phone
    String email
    Date dateOfLastSystemAccess
    Date dateOfFirstInterview
    Date dateOfLastInterview
    Integer numFamilies
    Integer numInterviewed
    Integer numDeclined

    def Integer getNumRemaining( ) {
        numFamilies - (numInterviewed + numDeclined)
    }
}

@Canonical
class RBlock {
    String blockCode
    Date dateOfFirstInterview
    Date dateOfLastInterview
    Integer numFamilies
    Integer numInterviewed
    Integer numDeclined

    def Integer getNumRemaining( ) {
        numFamilies - (numInterviewed + numDeclined)
    }

    List connectors = [ ]

}

@Canonical
class Result {
    String ncName = 'Marie-Danielle Lemm'
    String nhName = 'Bonnie Doon'
    List blocks
}

class BlockSummaryController {

    def index() {
        String query = "\
            select blk.code, count(loc.id), count(fam.id), min(fam.initialInterviewDate), max(fam.initialInterviewDate)\
            from Block as blk left outer join blk.locations as loc left outer join loc.families as fam group by blk.code"
        List blox = Block.executeQuery( query ).collect {
            [
                code: it[0],
                bcName: 'Grace Hopper',
                bcPhone: '333-444-5555',
                bcEmail: 'grace@abundantedmonton.ca',
                firstInterview: it[3],
                lastInterview: it[4],
                numFamilies: it[1],
                numInterviews: it[2],
                numDeclined: 0,
                numRemaining: it[1].longValue()-it[2].longValue()
            ]
        }
        [result:
            [
                ncName: 'Marie-Danielle',
                nhName: 'Bonnie Doon',
                blocks: blox
            ]
        ]
    }

    def synthetic() {
        def blox = [ ]
        def cons = [ ]
        blox << new RBlock( blockCode:'E7',  dateOfFirstInterview:new Date( '3/13/2013'), dateOfLastInterview:new Date( '10/5/2013'), numFamilies:0, numInterviewed:0, numDeclined:0, connectors:cons )

        cons = [ ]
        def c = new RBlockConnector( name:'Erin', phone:'123-456-7890', email:'erin@hotmail.cz', dateOfLastSystemAccess:new Date(), dateOfFirstInterview:new Date(), dateOfLastInterview:new Date(), numFamilies:12, numInterviewed:12, numDeclined:0 )
        cons << c
        blox << new RBlock( blockCode:'E35', dateOfFirstInterview:new Date( '3/13/2013'), dateOfLastInterview:new Date( '10/5/2013'), numFamilies:20, numInterviewed:12, numDeclined:1, connectors:cons )

        cons = [ ]
        c = new RBlockConnector( name:'Ryan', phone:'555-666-7777', email:'rr@ryanair.co.uk', dateOfLastSystemAccess:new Date(), dateOfFirstInterview:new Date(), dateOfLastInterview:new Date(), numFamilies:12, numInterviewed:12, numDeclined:0 )
        cons << c
        c = new RBlockConnector( name:'Francine', phone:'123-777-0022', email:'fvautour@shaw.ca', dateOfLastSystemAccess:new Date(), dateOfFirstInterview:new Date(), dateOfLastInterview:new Date(), numFamilies:12, numInterviewed:12, numDeclined:0 )
        cons << c
        blox << new RBlock( blockCode:'E9',  dateOfFirstInterview:new Date( '3/13/2013'), dateOfLastInterview:new Date( '10/5/2013'), numFamilies:20, numInterviewed:12, numDeclined:1, connectors:cons )

        Result r = new Result( ncName:'Marie-Danielle', nhName:'Bonnie Doon', blocks:blox )
        [ result: r ]
    }
}
