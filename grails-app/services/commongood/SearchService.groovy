package commongood

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

    def answers( session, q ) {
        answers( session, q, MIN_AGE, MAX_AGE )
    }

    def answersWithContactInfo( session, q ) {
        answersWithContactInfo( session, q, MIN_AGE, MAX_AGE )
    }

    def people( session, q ) {
        people( session, q, MIN_AGE, MAX_AGE )
    }

    def peopleWithContactInfo( session, q ) {
        peopleWithContactInfo( session, q, MIN_AGE, MAX_AGE )
    }

    def answers( session, q, fromAge, toAge ) {
        Integer fromYear = Year.now().getValue() - toAge
        Integer toYear = Year.now().getValue() - fromAge

        String qStr = "%${q.toLowerCase()}%"  // query string
        String qExp = parseQuery( q )         // query expression

        final Sql sql = new Sql(dataSource)
        def answers

        if( session.authorized.forNeighbourhood() ) {
            def neighbourhoodId = session.neighbourhood.id
            log.info "${session.user.logName} search hood ${neighbourhoodId} answers for '${q}', birthYears ${fromYear}:${toYear}"
            def select = 
                '''SELECT ans.text, ans.would_assist AS assist, ans.note, p.id AS pid, p.first_names AS firstNames, p.last_name AS lastName, q.short_text AS question
                 FROM Answer ans, Person p, Question q
                 WHERE ((TO_TSVECTOR(REGEXP_REPLACE(ans.text,'[.,/,-]',',')) || TO_TSVECTOR(REGEXP_REPLACE(ans.note,'[.,/,-]',',')) @@ TO_TSQUERY( :qExp ))
                        OR LOWER(ans.text) LIKE :qStr OR LOWER(ans.note) LIKE :qStr)
                 AND ans.person_id = p.id
                 AND ans.question_id = q.id
                 AND p.birth_year >= :fromYear AND p.birth_year <= :toYear
                 AND q.neighbourhood_id = :id
                 ORDER BY p.first_names, p.last_name, p.id'''

            answers = sql.rows( select, [ qStr:qStr, qExp:qExp, id:neighbourhoodId, fromYear:fromYear, toYear:toYear ] )

        } else {
            def blockId = session.block.id
            log.info "${session.user.logName} search block ${blockId} answers for '${q}', birthYears ${fromYear}:${toYear}"
            def select =
                '''SELECT ans.text, ans.would_assist AS assist, ans.note, p.id AS pid, p.first_names AS firstNames, p.last_name AS lastName, q.short_text AS question
                 FROM Answer ans, Person p, Family f, Address addr, Question q
                 WHERE ((TO_TSVECTOR(REGEXP_REPLACE(ans.text,'[.,/,-]',',')) || TO_TSVECTOR(REGEXP_REPLACE(ans.note,'[.,/,-]',',')) @@ TO_TSQUERY( :qExp ))
                        OR LOWER(ans.text) LIKE :qStr OR LOWER(ans.note) LIKE :qStr)
                 AND ans.person_id = p.id
                 AND ans.question_id = q.id 
                 AND p.family_id = f.id 
                 AND f.address_id = addr.id 
                 AND p.birth_year >= :fromYear AND p.birth_year <= :toYear
                 AND addr.block_id = :id 
                 ORDER BY p.first_names, p.last_name, p.id'''

            answers = sql.rows( select, [ qStr:qStr, qExp:qExp, id:blockId, fromYear:fromYear, toYear:toYear ] )
        }

        log.info "Found ${answers.size()} answers"
        return answers
    }

    def answersWithContactInfo( session, q, fromAge, toAge ) {
        Integer fromYear = Year.now().getValue() - toAge
        Integer toYear = Year.now().getValue() - fromAge

        String qStr = "%${q.toLowerCase()}%"  // query string
        String qExp = parseQuery( q )         // query expression

        final Sql sql = new Sql(dataSource)
        def answers

        if( session.authorized.forNeighbourhood() ) {
            def neighbourhoodId = session.neighbourhood.id
            log.info "${session.user.logName} search hood ${neighbourhoodId} answers for '${q}', birthYears ${fromYear}:${toYear} with contact info"

            def select =
                '''SELECT ans.text, ans.would_assist AS assist, ans.note, p.id AS pid, p.first_names AS firstNames, p.last_name AS lastName, q.short_text AS question,
                          p.phone_number AS phoneNumber, p.email_address AS emailAddress, addr.text AS homeAddress
                 FROM Answer ans, Person p, Family f, Address addr, Question q 
                 WHERE ((TO_TSVECTOR(REGEXP_REPLACE(ans.text,'[.,/,-]',',')) || TO_TSVECTOR(REGEXP_REPLACE(ans.note,'[.,/,-]',',')) @@ TO_TSQUERY( :qExp ))
                        OR LOWER(ans.text) LIKE :qStr OR LOWER(ans.note) LIKE :qStr)
                 AND ans.person_id = p.id 
                 AND ans.question_id = q.id 
                 AND p.birth_year >= :fromYear AND p.birth_year <= :toYear
                 AND q.neighbourhood_id = :id 
                 AND p.family_id = f.id 
                 AND f.address_id = addr.id 
                 ORDER BY p.first_names, p.last_name, p.id'''

            answers = sql.rows( select, [ qStr:qStr, qExp:qExp, id:neighbourhoodId, fromYear:fromYear, toYear:toYear ] )

        } else {
            def blockId = session.block.id
            log.info "${session.user.logName} search block ${blockId} answers for '${q}', birthYears ${fromYear}:${toYear} with contact info"

            def select =
                '''SELECT ans.text, ans.would_assist AS assist, ans.note, p.id AS pid, p.first_names AS firstNames, p.last_name AS lastName, q.short_text AS question,
                          p.phone_number AS phoneNumber, p.email_address AS emailAddress, addr.text AS homeAddress
                 FROM Answer ans, Person p, Family f, Address addr, Question q 
                 WHERE ((TO_TSVECTOR(REGEXP_REPLACE(ans.text,'[.,/,-]',',')) || TO_TSVECTOR(REGEXP_REPLACE(ans.note,'[.,/,-]',',')) @@ TO_TSQUERY( :qExp ))
                        OR LOWER(ans.text) LIKE :qStr OR LOWER(ans.note) LIKE :qStr)
                 AND ans.person_id = p.id 
                 AND ans.question_id = q.id 
                 AND p.family_id = f.id 
                 AND f.address_id = addr.id 
                 AND p.birth_year >= :fromYear AND p.birth_year <= :toYear
                 AND addr.block_id = :id 
                 ORDER BY p.first_names, p.last_name, p.id'''

            answers = sql.rows( select, [ qStr:qStr, qExp:qExp, id:blockId, fromYear:fromYear, toYear:toYear ] )
        }

        log.info "Found ${answers.size()} answers"
        return answers
    }

    def people( session, q, fromAge, toAge ) {
        Integer fromYear = Year.now().getValue() - toAge
        Integer toYear = Year.now().getValue() - fromAge

        def searchTerm = "%${q}%".toLowerCase( )
        def peeps

        if( session.authorized.forNeighbourhood() ) {
            def neighbourhoodId = session.neighbourhood.id
            log.info "${session.user.logName} search hood ${neighbourhoodId} people for '${q}', birthYears ${fromYear}:${toYear}"

            peeps = Person.executeQuery(
            'select p.id, p.firstNames, p.lastName \
             from Person p join p.family f join f.address a \
             where (lower(a.text) like :q or lower(a.note) like :q or lower(f.name) like :q or lower(f.note) like :q \
             or lower(p.firstNames) like :q or lower(p.lastName) like :q or lower(p.phoneNumber) like :q or lower(p.emailAddress) like :q \
             or lower(p.note) like :q) AND p.birthYear >= :fromYear AND p.birthYear <= :toYear \
             and a.block.neighbourhood.id = :id order by p.firstNames, p.lastName, p.id',
            [ q:searchTerm, id:neighbourhoodId, fromYear:fromYear, toYear:toYear ] )

        } else {
            def blockId = session.block.id
            log.info "${session.user.logName} search block ${blockId} people for '${q}', birthYears ${fromYear}:${toYear}"

            peeps = Person.executeQuery(
            'select p.id, p.firstNames, p.lastName \
             from Person p join p.family f join f.address a \
             where (lower(a.text) like :q or lower(a.note) like :q or lower(f.name) like :q or lower(f.note) like :q \
             or lower(p.firstNames) like :q or lower(p.lastName) like :q or lower(p.phoneNumber) like :q or lower(p.emailAddress) like :q \
             or lower(p.note) like :q) AND p.birthYear >= :fromYear AND p.birthYear <= :toYear \
             and a.block.id = :id \
             order by p.firstNames, p.lastName, p.id',
            [ q:searchTerm, id:blockId, fromYear:fromYear, toYear:toYear ] )
        }

        log.info "Found ${peeps.size()} people"
        return peeps
    }

    def peopleWithContactInfo( session, q, fromAge, toAge ) {
        Integer fromYear = Year.now().getValue() - toAge
        Integer toYear = Year.now().getValue() - fromAge

        def searchTerm = "%${q}%".toLowerCase( )
        def peeps

        if( session.authorized.forNeighbourhood() ) {
            def neighbourhoodId = session.neighbourhood.id
            log.info "${session.user.logName} search hood ${neighbourhoodId} people for '${q}', birthYears ${fromYear}:${toYear} with contact info"

            peeps = Person.executeQuery(
                'select p.id, p.firstNames, p.lastName, p.phoneNumber, p.emailAddress, a.text \
                 from Person p join p.family f join f.address a \
                 where (LOWER(a.text) like :q OR LOWER(a.note) like :q OR LOWER(f.name) like :q OR LOWER(f.note) like :q \
                 OR LOWER(p.firstNames) like :q OR LOWER(p.lastName) like :q OR LOWER(p.phoneNumber) like :q OR LOWER(p.emailAddress) like :q \
                 OR LOWER(p.note) like :q) AND p.birthYear >= :fromYear AND p.birthYear <= :toYear \
                 and a.block.neighbourhood.id = :id order by p.firstNames, p.lastName, p.id',
                [ q:searchTerm, id:neighbourhoodId, fromYear:fromYear, toYear:toYear ] )
        } else {
            def blockId = session.block.id
            log.info "${session.user.logName} search block ${blockId} people for '${q}', birthYears ${fromYear}:${toYear} with contact info"

            peeps = Person.executeQuery(
                'select p.id, p.firstNames, p.lastName, p.phoneNumber, p.emailAddress, a.text \
                 from Person p join p.family f join f.address a \
                 where (LOWER(a.text) like :q OR LOWER(a.note) like :q OR LOWER(f.name) like :q OR LOWER(f.note) like :q \
                 OR LOWER(p.firstNames) like :q OR LOWER(p.lastName) like :q OR LOWER(p.phoneNumber) like :q OR LOWER(p.emailAddress) like :q \
                 OR LOWER(p.note) like :q) AND p.birthYear >= :fromYear AND p.birthYear <= :toYear \
                 AND a.block.id = :id \
                 order by p.firstNames, p.lastName, p.id',
                [ q:searchTerm, id:blockId, fromYear:fromYear, toYear:toYear ] )
        }

        log.info "Found ${peeps.size()} people"
        return peeps
    }

    // Massage the query parameter before using PostgreSQL Full Text Search.
    def parseQuery( q ) {
        if( q.indexOf('&') >= 0 || q.indexOf('|') >= 0 || q.indexOf('!') >= 0 ) {
            log.info( 'Exotic search!')
            // Ex: "toy & !truck" searches for "toy" where "truck" is absent
            return q
        } else {
            // Make a query requiring all search terms; ex: "apple sauce" becomes "apple & sauce".
            // Experiments show PostgreSQL 9.4 full text search handles '/', '-' and '.' poorly.
            // Treat those characters like a space.
            return q.replaceAll( '[\\s,/,.,-]', ' & ' )
        } 
    }
}
