package commongood

class BlockConnectorSummaryController {

    def index() {
        String query = "\
            select fam.interviewer.firstNames, fam.interviewer.lastName, fam.interviewer.emailAddress, fam.interviewer.phoneNumber,\
                count(fam.id), min(fam.initialInterviewDate), max(fam.initialInterviewDate)\
                from Block as blk left outer join blk.locations as loc left outer join loc.families as fam\
                group by fam.interviewer.firstNames, fam.interviewer.lastName, fam.interviewer.emailAddress, fam.interviewer.phoneNumber"
        List conex = Block.executeQuery( query ).collect {
            [
                bcName: it[0]+' '+it[1],
                bcEmail: it[2],
                bcPhone: it[3],
                firstInterview: it[5],
                lastInterview: it[6],
                numFamilies: it[4],
                numDeclined: 99
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
