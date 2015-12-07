package commongood

class BlockConnectorSummaryController {

    def index() {
        String query = "\
            select blk.code, count(loc.id), count(fam.id), min(fam.initialInterviewDate), max(fam.initialInterviewDate)\
            from Block as blk left outer join blk.locations as loc left outer join loc.families as fam group by blk.code"
        List conex = Block.executeQuery( query ).collect {
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
                connectors: conex
            ]
        ]
    }
}
