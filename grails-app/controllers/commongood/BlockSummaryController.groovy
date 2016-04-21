package commongood

import groovy.sql.Sql

class BlockSummaryController {
    // Grails injects the default DataSource
    def dataSource
    def authorizationService

    def index() {
        def hoodId = session.neighbourhood.id
        authorizationService.neighbourhood( hoodId, session )

        log.info "${session.user.getLogName()} Block Summary for neighbourhood/${hoodId}"
        // Eschew GORM; let's kick it ol' school...
        def query = '''SELECT blk.id AS blockId,
                            blk.code,
                            blk.description,
                            addr.id AS addressId,
                            fam.interview_date,
                            fam.participate_in_interview
                     FROM Block AS blk
                       LEFT OUTER JOIN address AS addr ON blk.id = addr.block_id
                       LEFT OUTER JOIN family AS fam ON addr.id = fam.address_id
                    WHERE blk.neighbourhood_id = :neighbourhoodId
                    ORDER BY blk.order_within_neighbourhood,
                             blk.id,
                             addr.order_within_block,
                             addr.id'''

        final Sql sql = new Sql(dataSource)
        def fams = sql.rows( query, [neighbourhoodId:hoodId] )

        def blocks = [ ]
        def lastCode = null
        def lastBlockId = null
        def lastDescription = null
        def countFamilies = 0
        def countInterviews = 0
        def countPartyPoopers = 0
        def firstInterview = null
        def lastInterview = null

        fams.each{
            if( lastBlockId && it.blockId != lastBlockId ) {
                blocks << [
                    id: lastBlockId,
                    code: lastCode,
                    description: lastDescription,
                    firstInterview: firstInterview,
                    lastInterview: lastInterview,
                    numFamilies: countFamilies,
                    numInterviews: countInterviews,
                    numDeclined: countPartyPoopers,
                    numRemaining: countFamilies - (countInterviews+countPartyPoopers)
                ]
                countFamilies = 0
                countInterviews = 0
                countPartyPoopers = 0
                firstInterview = null
                lastInterview = null
            }
            if( it.addressId ) {
                // Counts N families at one address N times (correct)
                countFamilies++
            }
            if( it.interview_date ) {
                if( it.participate_in_interview ) {
                    countInterviews++
                } else {
                    countPartyPoopers++
                }

                if( !firstInterview || it.interview_date.before(firstInterview) ) {
                    firstInterview = it.interview_date
                }

                if( !lastInterview || it.interview_date.after(lastInterview) ) {
                    lastInterview = it.interview_date
                }
            }
            lastCode = it.code
            lastBlockId = it.blockId
            lastDescription = it.description
        }

        blocks << [
           id: lastBlockId,
           code: lastCode,
           description: lastDescription,
           firstInterview: firstInterview,
           lastInterview: lastInterview,
           numFamilies: countFamilies,
           numInterviews: countInterviews,
           numDeclined: countPartyPoopers,
           numRemaining: countFamilies - countInterviews
       ]

        [result:
            [
                blocks: blocks
            ]
        ]
    }
}