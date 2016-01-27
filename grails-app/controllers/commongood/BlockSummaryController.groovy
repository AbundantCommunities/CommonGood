package commongood

import groovy.sql.Sql

class BlockSummaryController {
    // Grails inkects the default DataSource
    def dataSource

    def index() {
        // Eschew GORM; let's kick it ol' school...
        def id = 1L
        def query = '''SELECT blk.id AS blockId,
                        blk.code,
                        addr.id as addressId,
                        fam.id AS familyId,
                        fam.interview_date,
                        fam.participate_in_interview
                    FROM (Block AS blk
                      inner JOIN address AS addr ON blk.id = addr.block_id)
                      LEFT OUTER JOIN family AS fam ON addr.id = fam.address_id
                    ORDER BY blk.order_within_neighbourhood,
                             addr.order_within_block'''

        final Sql sql = new Sql(dataSource)
        def fams = sql.rows( query )

        def blocks = [ ]
        def lastBlock = null
        def countFamilies = 0
        def countInterviews = 0
        def countPartyPoopers = 0
        def firstInterview = null
        def lastInterview = null

        fams.each{
            def block = it.blockId
            if( block != lastBlock ) {
                if( lastBlock ) {
                    def bc = getBlockConnector( lastBlock )
                    blocks << [
                        code: it.code,
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
            if( it.addressId ) {
                countFamilies++
            }
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
            lastBlock = block
        }

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