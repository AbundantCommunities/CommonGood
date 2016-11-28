package commongood

class BlockConnectorSummaryController {

    def index() {
        // This def and call to our authorizationService accomplishes very little
        // but without it, the code appears to lack authorization enforcement...
        def hoodId = session.neighbourhood.id
        authorizationService.neighbourhoodRead( hoodId, session )

        String query = "\
            select fam.interviewer.firstNames, fam.interviewer.lastName, fam.interviewer.emailAddress, fam.interviewer.phoneNumber, \
                count(fam.interviewDate), min(fam.interviewDate), max(fam.interviewDate), \
                SUM(CASE WHEN fam.participateInInterview = FALSE THEN 1 ELSE 0 END) AS Declined \
                from Block as blk left outer join blk.addresses as loc left outer join loc.families as fam \
                where blk.neighbourhood.id = :neighbourhoodId \
                group by fam.interviewer.firstNames, fam.interviewer.lastName, fam.interviewer.emailAddress, fam.interviewer.phoneNumber"
        List conex = Block.executeQuery( query, [neighbourhoodId:hoodId] ).collect {
            [
                bcName: it[0]+' '+it[1],
                bcEmail: it[2],
                bcPhone: it[3],
                firstInterview: it[5],
                lastInterview: it[6],
                numFamilies: it[4],
                numDeclined: it[7]
            ]
        }
        [result:
            [
                connectors: conex
            ]
        ]
    }
}
