package commongood

import groovy.sql.Sql

class BlockSummaryController {
    // Grails injects the default DataSource
    def dataSource

    def index() {
        // Eschew GORM; let's kick it ol' school...
        def query = '''SELECT blk.id AS blockId,
                        blk.code AS blockCode,
                        blk.description AS blockDescription,
                        addr.id as addressId,
                        fam.id AS familyId,
                        fam.interview_date,
                        fam.participate_in_interview
                    FROM (Block AS blk
                      inner JOIN address AS addr ON blk.id = addr.block_id
                                AND blk.neighbourhood_id = :neighbourhoodId)
                      LEFT OUTER JOIN family AS fam ON addr.id = fam.address_id
                    ORDER BY blk.order_within_neighbourhood,
                             addr.order_within_block'''

        final Sql sql = new Sql(dataSource)
        def fams = sql.rows( query, [neighbourhoodId: session.neighbourhood.id] )

        def blocks = [ ]
        def lastBlockCode = null
        def lastBlockId = null
        def lastBlockDescription = null
        def countFamilies = 0
        def countInterviews = 0
        def countPartyPoopers = 0
        def firstInterview = null
        def lastInterview = null

        fams.each{
            if( it.blockId != lastBlockId ) {
                if( lastBlockId ) {
                    def bc = getBlockConnector( lastBlockId )
                    blocks << [
                        id: lastBlockId,
                        code: lastBlockCode,
                        description: lastBlockDescription,
                        bcName: bc.fullName,
                        bcPhone: bc.phoneNumber,
                        bcEmail: bc.emailAddress,
                        firstInterview: firstInterview,
                        lastInterview: lastInterview,
                        numFamilies: countFamilies,
                        numInterviews: countInterviews,
                        numDeclined: countPartyPoopers,
                        numRemaining: countFamilies - countInterviews
                    ]
                    countFamilies = 0
                    countInterviews = 0
                    countPartyPoopers = 0
                    firstInterview = null
                    lastInterview = null
                }
            }
            countFamilies++
            if( it.interview_date ) {
                countInterviews++
                if( !it.participate_in_interview ) {
                    countPartyPoopers++
                }

                if( !firstInterview || it.interview_date.before(firstInterview) ) {
                    firstInterview = it.interview_date
                }

                if( !lastInterview || it.interview_date.after(lastInterview) ) {
                    lastInterview = it.interview_date
                }
            }
            lastBlockCode = it.blockCode
            lastBlockId = it.blockId
            lastBlockDescription = it.blockDescription
        }

        def bc = getBlockConnector( lastBlockId )
        blocks << [
            id: lastBlockId,
            code: lastBlockCode,
            bcName: bc.fullName,
            bcPhone: bc.phoneNumber,
            bcEmail: bc.emailAddress,
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

    def getBlockConnector( Long blockId ) {
        // There can be multiple DomainAuthorization rows for a given block id
        // but we just want one.
        def rights = DomainAuthorization.createCriteria().list {
            and {
                eq 'domainCode', DomainAuthorization.BLOCK
                // FIXME Allow Long blockId (converting to Integer not good!)
                eq 'domainKey', blockId.toInteger( )
            }
        }

        if( rights[0] ) {
            return rights[0].person
        } else {
            // No BC for this block; use the signed-in NC
            return session.user
        }
    }
}