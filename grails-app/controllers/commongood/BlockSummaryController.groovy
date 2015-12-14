package commongood

class BlockSummaryController {

    def index() {
        String query = "\
            select blk.code, blk.id, count(loc.id), count(fam.id), min(fam.initialInterviewDate), max(fam.initialInterviewDate),\
            SUM(CASE WHEN fam.participateInInterview = FALSE THEN 1 ELSE 0 END) AS Declined\
            from Block as blk left outer join blk.locations as loc left outer join loc.families as fam group by blk.code, blk.id"
        List blox = Block.executeQuery( query ).collect {
            [
                code: it[0],
                // TODO If we replace 'collect' with 'each' we won't hit Block table 3 times
                bcName: getBlockConnector(it[1]).fullName,
                bcPhone: getBlockConnector(it[1]).phoneNumber,
                bcEmail: getBlockConnector(it[1]).emailAddress,
                firstInterview: it[4],
                lastInterview: it[5],
                numFamilies: it[2],
                numInterviews: it[3].longValue() - it[6].longValue(),
                numDeclined: it[6],
                numRemaining: it[2].longValue() - it[3].longValue()
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

    def getBlockConnector( Long blockId ) {
        // There can be multiple DomainAuthorization rows for a given block id
        // but we just want one (thus the call to find).
        def rights = DomainAuthorization.createCriteria().list {
                and {
                    eq 'domainCode', DomainAuthorization.BLOCK
                    // FIXME allow Long blockId (converting to Integer not good!)
                    eq 'domainKey', blockId.toInteger( )
                }
        }
        // FIXME handle when no such blockId??
        return rights[0].person
    }
}