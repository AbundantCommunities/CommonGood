package commongood

import org.abundantcommunityinitiative.commongood.Authorization
import grails.transaction.Transactional
import groovy.sql.Sql

@Transactional
class BlockService {
    // Grails injects the default DataSource
    def dataSource

    // Get all the blocks for a neighbourhood or only the blocks that a BC is
    // authorized to access.
    def getForNeighbourhood( authorized ) {
        def query
        if( authorized.forNeighbourhood() ) {
            query = '''SELECT blk.id, blk.code, blk.description, da.person_id, bc.first_names, bc.last_name
                        FROM block AS blk LEFT OUTER JOIN domain_authorization AS da ON blk.id = da.domain_key
                            LEFT OUTER JOIN person AS bc ON da.person_id = bc.id
                        WHERE (da.domain_code = 'B' OR da.domain_code IS NULL)
                        AND blk.neighbourhood_id = :queryId
                        ORDER BY blk.order_within_neighbourhood'''

        } else {
            query = '''SELECT blk.id, blk.code, blk.description, da.person_id, bc.first_names, bc.last_name
                        FROM block AS blk LEFT OUTER JOIN domain_authorization AS da ON blk.id = da.domain_key
                            LEFT OUTER JOIN person AS bc ON da.person_id = bc.id
                        WHERE (da.domain_code = 'B' OR da.domain_code IS NULL)
                        AND blk.id = :queryId'''
        }

        final Sql sql = new Sql(dataSource)
        def bloxWithConnectors = sql.rows( query, [queryId: authorized.domainKey] )

        def blox = [ ]
        def currentBlockId = null
        def connectors = [ ]

        bloxWithConnectors.each{
            if( it.id != currentBlockId ) {
                connectors = [ ]
                blox << [ id:it.id, code:it.code, description:it.description, connectors:connectors ]
            }
            currentBlockId = it.id
            if( it.person_id ) {
                connectors << [ id:it.person_id, firstNames:it.first_names, lastName:it.last_name ]
            }
        }
        return blox
    }
}
