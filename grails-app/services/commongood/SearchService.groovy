package commongood

import org.abundantcommunityinitiative.gis.Location

import java.time.Year
import grails.transaction.Transactional
import groovy.sql.Sql

@Transactional
class SearchService {
    // Grails injects the default DataSource
    def dataSource

    // We use these minimum and maximum ages to keep things clear & simple.
    static Integer MIN_AGE = -199
    static Integer MAX_AGE =  199

    // IMPORTANT NOTE RE LOGGING
    // We call log.info before and after each query, to monitor performance
    // Some of these searches have the potential to run very slowly.

    def answersWithContactInfo( session, q ) {
        answersWithContactInfo( session, q, MIN_AGE, MAX_AGE )
    }

    def people( session, q ) {
        people( session, q, MIN_AGE, MAX_AGE )
    }

    def peopleWithContactInfo( session, q ) {
        peopleWithContactInfo( session, q, MIN_AGE, MAX_AGE )
    }

    def answersWithContactInfo( session, q, fromAge, toAge ) {
        Integer fromYear = Year.now().getValue() - toAge
        Integer toYear = Year.now().getValue() - fromAge

        String qStr = simpleQuery( q )    // for simple string search
        String qExp = fullTextQuery( q )  // for Postgres Full Text Search

        final Sql sql = new Sql(dataSource)
        def answers

        if( session.authorized.forNeighbourhood() ) {
            def neighbourhoodId = session.neighbourhood.id
            log.info "${session.user.logName} search hood ${neighbourhoodId} answers for '${q}', birthYears ${fromYear}:${toYear} with contact info"

            def select =
                '''SELECT ans.text, ans.would_assist AS assist, ans.note, 
                          p.id AS pid, p.first_names AS firstNames, p.last_name AS lastName, 
                          q.short_text AS question,
                          p.phone_number AS phoneNumber, p.email_address AS emailAddress, 
                          addr.id AS addrId, addr.text AS homeAddress, blk.code AS blockCode
                 FROM Answer ans, Person p, Family f, Address addr, Block blk, Question q
                 WHERE ((TO_TSVECTOR(REGEXP_REPLACE(ans.text,'[.,/,-]',',')) || TO_TSVECTOR(REGEXP_REPLACE(ans.note,'[.,/,-]',',')) @@ TO_TSQUERY( :qExp ))
                        OR LOWER(ans.text) LIKE :qStr OR LOWER(ans.note) LIKE :qStr)
                 AND ans.person_id = p.id 
                 AND ans.question_id = q.id ''' +
                 ageSelectionSQL( fromYear, toYear ) +
                 ''' AND q.neighbourhood_id = :id 
                 AND p.family_id = f.id 
                 AND f.address_id = addr.id
                 AND addr.block_id = blk.id
                 ORDER BY p.first_names, p.last_name, p.id'''

            answers = sql.rows( select, [ qStr:qStr, qExp:qExp, id:neighbourhoodId, fromYear:fromYear, toYear:toYear ] )

        } else {
            def blockId = session.block.id
            log.info "${session.user.logName} search block ${blockId} answers for '${q}', birthYears ${fromYear}:${toYear} with contact info"

            def select =
                '''SELECT ans.text, ans.would_assist AS assist, ans.note, 
                          p.id AS pid, p.first_names AS firstNames, p.last_name AS lastName, 
                          q.short_text AS question,
                          p.phone_number AS phoneNumber, p.email_address AS emailAddress, 
                          addr.id AS addrId, addr.text AS homeAddress, blk.code AS blockCode
                 FROM Answer ans, Person p, Family f, Address addr, Block blk, Question q
                 WHERE ((TO_TSVECTOR(REGEXP_REPLACE(ans.text,'[.,/,-]',',')) || TO_TSVECTOR(REGEXP_REPLACE(ans.note,'[.,/,-]',',')) @@ TO_TSQUERY( :qExp ))
                        OR LOWER(ans.text) LIKE :qStr OR LOWER(ans.note) LIKE :qStr)
                 AND ans.person_id = p.id 
                 AND ans.question_id = q.id 
                 AND p.family_id = f.id 
                 AND f.address_id = addr.id
                 AND addr.block_id = blk.id ''' +
                 ageSelectionSQL( fromYear, toYear ) +
                 ''' AND addr.block_id = :id 
                 ORDER BY p.first_names, p.last_name, p.id'''

            answers = sql.rows( select, [ qStr:qStr, qExp:qExp, id:blockId, fromYear:fromYear, toYear:toYear ] )
        }

        log.info "Found ${answers.size()} answers"
        return answers
    }

    // TODO Looks like people() can be removed because we always call peopleWithContactInfo()
    def people( session, q, fromAge, toAge ) {
        peopleWithContactInfo( session, q, fromAge, toAge )
    }

    def peopleWithContactInfo( session, q, fromAge, toAge ) {
        Integer fromYear = Year.now().getValue() - toAge
        Integer toYear = Year.now().getValue() - fromAge

        def searchTerm = simpleQuery( q )
        def peeps

        if( session.authorized.forNeighbourhood() ) {
            def neighbourhoodId = session.neighbourhood.id
            log.info "${session.user.logName} search hood ${neighbourhoodId} people for '${q}', birthYears ${fromYear}:${toYear}"

            peeps = Person.executeQuery(
                'select p.id, p.firstNames, p.lastName, p.phoneNumber, p.emailAddress, a.text, b.code \
                 from Person p join p.family f join f.address a join a.block b \
                 where (LOWER(a.text) like :q OR LOWER(a.note) like :q OR LOWER(f.name) like :q OR LOWER(f.note) like :q \
                 OR LOWER(p.firstNames) like :q OR LOWER(p.lastName) like :q OR LOWER(p.phoneNumber) like :q OR LOWER(p.emailAddress) like :q \
                 OR LOWER(p.note) like :q) ' +
                 ageSelectionHQL( fromYear, toYear ) +
                 ' and a.block.neighbourhood.id = :id order by p.firstNames, p.lastName, p.id',
                [ q:searchTerm, id:neighbourhoodId, fromYear:fromYear, toYear:toYear ] )
        } else {
            def blockId = session.block.id
            log.info "${session.user.logName} search block ${blockId} people for '${q}', birthYears ${fromYear}:${toYear}"

            peeps = Person.executeQuery(
                'select p.id, p.firstNames, p.lastName, p.phoneNumber, p.emailAddress, a.text, b.code \
                 from Person p join p.family f join f.address a join a.block b \
                 where (LOWER(a.text) like :q OR LOWER(a.note) like :q OR LOWER(f.name) like :q OR LOWER(f.note) like :q \
                 OR LOWER(p.firstNames) like :q OR LOWER(p.lastName) like :q OR LOWER(p.phoneNumber) like :q OR LOWER(p.emailAddress) like :q \
                 OR LOWER(p.note) like :q) ' +
                 ageSelectionHQL( fromYear, toYear ) +
                 ' AND a.block.id = :id \
                 order by p.firstNames, p.lastName, p.id',
                [ q:searchTerm, id:blockId, fromYear:fromYear, toYear:toYear ] )
        }

        log.info "Found ${peeps.size()} people"
        return peeps
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

    def ageSelectionSQL( fromYear, toYear ) {
        // We deployed a bug to production in version 1.10.
        // This is our urgent, ugly but simple fix.
        if( fromYear < 1850 ) {
            if( toYear > 2200 ) {
                return ''
            } else {
                return 'AND p.birth_year != 0 AND p.birth_year <= :toYear'
            }
        } else {
            if( toYear > 2200 ) {
                return 'AND p.birth_year >= :fromYear'
            } else {
                return 'AND p.birth_year >= :fromYear AND p.birth_year <= :toYear'
            }
        }
    }

    def ageSelectionHQL( fromYear, toYear ) {
        // We deployed a bug to production in version 1.10.
        // This is our urgent, ugly but simple fix.
        // BOTH :fromYear and :toYear MUST be in the return value.
        if( fromYear < 1850 ) {
            if( toYear > 2200 ) {
                return 'AND p.birthYear != :fromYear AND p.birthYear != :toYear'
            } else {
                return 'AND p.birthYear != 0 AND p.birthYear != :fromYear AND p.birthYear <= :toYear'
            }
        } else {
            if( toYear > 2200 ) {
                return 'AND p.birthYear >= :fromYear AND p.birthYear != :toYear'
            } else {
                return 'AND p.birthYear >= :fromYear AND p.birthYear <= :toYear'
            }
        }
    }

    /**
     * A stepping stone, on the way to a clean, nice way to return GIS coordinates to the SearchController.
     * @param foundAnswers List of maps, each map representing a found answer
     * @result  List<Location> of locations (where our results HAD lat+lon locations)
     */
    def deriveLocations ( foundAnswers ) {
        // TODO merge deriveLocations into answersWithContactInfo
        log.info "deriveLocations for ${foundAnswers.size()} answers"
        def result = [:]
        def countLocatedAnswers = 0
        foundAnswers.each {
            Address address = Address.get( it.addrId )
            Block block = address.block
            Location location = address.latLon()
            Person person = Person.get( it.pid )

            if( !location.unknown ) {
                countLocatedAnswers++
            }

            if( block in result ) {
                def blockAnswers = result[ block ]
                if( person in blockAnswers ) {
                    // Append the answer to the list of answers from person
                    blockAnswers[person] << it
                } else {
                    // Add this person to the blockAnswers map
                    // The person will have (at least for now) just one answer in its list
                    blockAnswers[person] = [ it ]
                }
            } else {
                // Make an entry for this block; the entry will have (at least for now) just one person in its map
                // We write (person) else the key will be the string 'person'.
                result[block] = [ (person):[it] ]
            }
        }
        log.info "Pulled ${result.size()} locations with ${countLocatedAnswers} answers"
        return result
    }
}
