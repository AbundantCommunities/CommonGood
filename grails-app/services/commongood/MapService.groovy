package commongood

import grails.transaction.Transactional
import groovy.sql.Sql

@Transactional
class MapService {

    // Grails injects the default DataSource
    def dataSource
    
    // ----------====>  IMPORTANT NOTE RE LOGGING  <====----------
    // We call log.info before and after each query, to monitor performance
    // Some of these searches have the potential to run very slowly.

    
    // Neighbourhood-wide ONLY  (no block search)

    def answers( neighbourhood, q ) {

        String qStr  = simpleQuery( q )    // for simple string search
        String qExpr = fullTextQuery( q )  // for Postgres Full Text Search

        log.info "Search ${neighbourhood} answers for '${q}'"

        def select = '''
SELECT ans.text, ans.would_assist AS assist, ans.note, 
    p.id AS personId, p.first_names AS firstNames, p.last_name AS lastName, p.phone_number AS phoneNumber, p.email_address AS emailAddress,
    addr.text AS homeAddress,
    blk.id as blockId, blk.centre_latitude as bcLatitude, blk.centre_longitude as bcLongitude,
    q.short_text AS question

FROM Answer ans, Person p, Family f, Address addr, Question q, Block blk

WHERE (
        (TO_TSVECTOR(REGEXP_REPLACE(ans.text,'[.,/,-]',',')) || TO_TSVECTOR(REGEXP_REPLACE(ans.note,'[.,/,-]',',')) @@ TO_TSQUERY( :qExp ))
        OR LOWER(ans.text) LIKE :qStr
        OR LOWER(ans.note) LIKE :qStr
      )
AND ans.person_id = p.id 
AND ans.question_id = q.id
AND q.neighbourhood_id = :neighbourhoodId 
AND p.family_id = f.id 
AND f.address_id = addr.id 
AND addr.block_id = blk.id

ORDER BY p.first_names, p.last_name, p.id
'''
        final Sql sql = new Sql(dataSource)
        def answers = sql.rows( select, [ qStr: qStr, qExpr: qExpr, neighbourhoodId: neighbourhood.id ] )

        // Produce a map whose key is a representation of Block, [id,latitude,longitude].
        // Each value is a list of maps where each map is one row from the SELECT (the maps "belong" to the block).
        // A row's map is like [text:wine, assist:false, note:, personid:2029, firstnames:Herb, ...]
        def answersByBlock = answers.groupBy({ [ id:it.blockId, latitude:it.bcLatitude, longitude:it.bcLongitude] })

        // Remove blocks that have no map location
        def noMapBlocks = [ ]
        def count = 0
        answersByBlock.each { k, v ->
            if( k.latitude ) {
                count += v.size( )
            } else {
                noMapBlocks << k
            }
        }
        noMapBlocks.each {
            answersByBlock.remove( it )
        }

        log.info "Found ${count} answers in ${answersByBlock.size()} blocks (removed the ${noMapBlocks.size()} blocks without location)"
        return answersByBlock
    }

    def simpleQuery( q ) {
        // Used with SELECT ... WHERE field LIKE simpleQuery
        "%${q.trim().toLowerCase()}%"
    }

    def fullTextQuery( q ) {
        // used with Postgres Full Text Search.
        if( q.indexOf('&') >= 0 || q.indexOf('|') >= 0 || q.indexOf('!') >= 0 ) {
            log.info( 'Exotic search!')
            // Ex: "toy & !truck" searches for "toy" where "truck" is absent
            return q
        } else {
            // Make a query requiring all search terms; ex: "apple sauce" becomes "apple & sauce".
            // Experiments show PostgreSQL 9.4 full text search handles '/', '-' and '.' poorly.
            // Treat those characters like a space.
            return q.trim().replaceAll( '[\\s,/,.,-]', ' ' ).replaceAll(' +', ' & ')
        } 
    }
}
