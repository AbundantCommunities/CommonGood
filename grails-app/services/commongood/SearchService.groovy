package commongood

import grails.transaction.Transactional

@Transactional
class SearchService {

    // IMPORTANT NOTE RE LOGGING
    // We call log.info before and after each query, to monitor performance
    // Some of these searches have the potential to run very slowly.

    def answers( session, q ) {
        answers( session, q, Integer.MIN_VALUE, Integer.MAX_VALUE )
    }

    def answersWithContactInfo( session, q ) {
        answersWithContactInfo( session, q, Integer.MIN_VALUE, Integer.MAX_VALUE )
    }

    def people( session, q ) {
        people( session, q, Integer.MIN_VALUE, Integer.MAX_VALUE )
    }

    def peopleWithContactInfo( session, q ) {
        peopleWithContactInfo( session, q, Integer.MIN_VALUE, Integer.MAX_VALUE )
    }

    def answers( session, q, fromYear, toYear ) {
        def searchTerm = "%${q}%".toLowerCase( )
        def answers

        if( session.authorized.forNeighbourhood() ) {
            def neighbourhoodId = session.neighbourhood.id
            log.info "${session.user.logName} search hood ${neighbourhoodId} answers for '${q}', birthYears ${fromYear}:${toYear}"
            answers = Answer.executeQuery(
                'SELECT ans.text, ans.wouldAssist, p.id, p.firstNames, p.lastName, q.shortText \
                 FROM Answer ans, Person p, Question q \
                 WHERE (LOWER(ans.text) LIKE :q OR LOWER(ans.note) LIKE :q) \
                 AND ans.person.id = p.id \
                 AND ans.question.id = q.id \
                 AND ((p.birthYear >= :fromYear AND p.birthYear <= :toYear) OR p.birthYear = 0) \
                 AND q.neighbourhood.id = :id \
                 ORDER BY p.firstNames, p.lastName, p.id',
                [ q:searchTerm, id:neighbourhoodId, fromYear:fromYear, toYear:toYear ] )
        } else {
            def blockId = session.block.id
            log.info "${session.user.logName} search block ${blockId} answers for '${q}', birthYears ${fromYear}:${toYear}"
            answers = Answer.executeQuery(
                'SELECT ans.text, ans.wouldAssist, p.id, p.firstNames, p.lastName, q.shortText \
                 FROM Answer ans, Person p, Family f, Address addr, Question q \
                 WHERE (LOWER(ans.text) LIKE :q OR LOWER(ans.note) LIKE :q) \
                 AND ans.person.id = p.id \
                 AND ans.question.id = q.id \
                 AND p.family.id = f.id \
                 AND f.address.id = addr.id \
                 AND ((p.birthYear >= :fromYear AND p.birthYear <= :toYear) OR p.birthYear = 0) \
                 AND addr.block.id = :id \
                 ORDER BY p.firstNames, p.lastName, p.id',
                [ q:searchTerm, id:blockId, fromYear:fromYear, toYear:toYear ] )
        }

        log.info "Found ${answers.size()} answers"
        return answers
    }

    def answersWithContactInfo( session, q, fromYear, toYear ) {
        def searchTerm = "%${q}%".toLowerCase( )
        def answers

        if( session.authorized.forNeighbourhood() ) {
            def neighbourhoodId = session.neighbourhood.id
            log.info "${session.user.logName} searching neighbourhood ${neighbourhoodId} answers for '${q}', birthYears ${fromYear}:${toYear} with contact info"

            answers = Answer.executeQuery(
                'SELECT ans.text, ans.wouldAssist, p.id, p.firstNames, p.lastName, q.shortText, \
                 p.phoneNumber, p.emailAddress, addr.text \
                 FROM Answer ans, Person p, Family f, Address addr, Question q \
                 WHERE (LOWER(ans.text) LIKE :q OR LOWER(ans.note) LIKE :q) \
                 AND ans.person.id = p.id \
                 AND ans.question.id = q.id \
                 AND ((p.birthYear >= :fromYear AND p.birthYear <= :toYear) OR p.birthYear = 0) \
                 AND q.neighbourhood.id = :id \
                 AND p.family.id = f.id \
                 AND f.address.id = addr.id \
                 ORDER BY p.firstNames, p.lastName, p.id',
                [ q:searchTerm, id:neighbourhoodId, fromYear:fromYear, toYear:toYear ] )
        } else {
            def blockId = session.block.id
            log.info "${session.user.logName} searching block ${blockId} answers for ${q} (with contact info)"

            answers = Answer.executeQuery(
                'SELECT ans.text, ans.wouldAssist, p.id, p.firstNames, p.lastName, q.shortText, \
                 p.phoneNumber, p.emailAddress, addr.text \
                 FROM Answer ans, Person p, Family f, Address addr, Question q \
                 WHERE (LOWER(ans.text) LIKE :q OR LOWER(ans.note) LIKE :q) \
                 AND ans.person.id = p.id \
                 AND ans.question.id = q.id \
                 AND p.family.id = f.id \
                 AND f.address.id = addr.id \
                 AND ((p.birthYear >= :fromYear AND p.birthYear <= :toYear) OR p.birthYear = 0) \
                 AND addr.block.id = :id \
                 ORDER BY p.firstNames, p.lastName, p.id',
                [ q:searchTerm, id:blockId, fromYear:fromYear, toYear:toYear ] )
        }

        log.info "Found ${answers.size()} answers"
        return answers
    }

    def people( session, q, fromYear, toYear ) {
        def searchTerm = "%${q}%".toLowerCase( )
        def peeps

        if( session.authorized.forNeighbourhood() ) {
            def neighbourhoodId = session.neighbourhood.id
            log.info "${session.user.logName} searching neighbourhood ${neighbourhoodId} people for '${q}', birthYears ${fromYear}:${toYear}"

            peeps = Person.executeQuery(
            'select p.id, p.firstNames, p.lastName \
             from Person p join p.family f join f.address a \
             where (lower(a.text) like :q or lower(a.note) like :q or lower(f.name) like :q or lower(f.note) like :q \
             or lower(p.firstNames) like :q or lower(p.lastName) like :q or lower(p.phoneNumber) like :q or lower(p.emailAddress) like :q \
             or lower(p.note) like :q) AND ((p.birthYear >= :fromYear AND p.birthYear <= :toYear) OR p.birthYear = 0) \
             and a.block.neighbourhood.id = :id order by p.firstNames, p.lastName, p.id',
            [ q:searchTerm, id:neighbourhoodId, fromYear:fromYear, toYear:toYear ] )

        } else {
            def blockId = session.block.id
            log.info "${session.user.logName} searching block ${blockId} people for ${q}"

            peeps = Person.executeQuery(
            'select p.id, p.firstNames, p.lastName \
             from Person p join p.family f join f.address a \
             where (lower(a.text) like :q or lower(a.note) like :q or lower(f.name) like :q or lower(f.note) like :q \
             or lower(p.firstNames) like :q or lower(p.lastName) like :q or lower(p.phoneNumber) like :q or lower(p.emailAddress) like :q \
             or lower(p.note) like :q) AND ((p.birthYear >= :fromYear AND p.birthYear <= :toYear) OR p.birthYear = 0) \
             and a.block.id = :id \
             order by p.firstNames, p.lastName, p.id',
            [ q:searchTerm, id:blockId, fromYear:fromYear, toYear:toYear ] )
        }

        log.info "Found ${peeps.size()} people"
        return peeps
    }

    def peopleWithContactInfo( session, q, fromYear, toYear ) {
        def searchTerm = "%${q}%".toLowerCase( )
        def peeps

        if( session.authorized.forNeighbourhood() ) {
            def neighbourhoodId = session.neighbourhood.id
            log.info "Searching NH ${neighbourhoodId} people for '${q}', birthYears ${fromYear}:${toYear} with contact info"

            peeps = Person.executeQuery(
                'select p.id, p.firstNames, p.lastName, p.phoneNumber, p.emailAddress, a.text \
                 from Person p join p.family f join f.address a \
                 where (LOWER(a.text) like :q OR LOWER(a.note) like :q OR LOWER(f.name) like :q OR LOWER(f.note) like :q \
                 OR LOWER(p.firstNames) like :q OR LOWER(p.lastName) like :q OR LOWER(p.phoneNumber) like :q OR LOWER(p.emailAddress) like :q \
                 OR LOWER(p.note) like :q) AND ((p.birthYear >= :fromYear AND p.birthYear <= :toYear) OR p.birthYear = 0) \
                 and a.block.neighbourhood.id = :id order by p.firstNames, p.lastName, p.id',
                [ q:searchTerm, id:neighbourhoodId, fromYear:fromYear, toYear:toYear ] )
        } else {
            def blockId = session.block.id
            log.info "Searching block ${blockId} people for ${q} (with contact info)"

            peeps = Person.executeQuery(
                'select p.id, p.firstNames, p.lastName, p.phoneNumber, p.emailAddress, a.text \
                 from Person p join p.family f join f.address a \
                 where (LOWER(a.text) like :q OR LOWER(a.note) like :q OR LOWER(f.name) like :q OR LOWER(f.note) like :q \
                 OR LOWER(p.firstNames) like :q OR LOWER(p.lastName) like :q OR LOWER(p.phoneNumber) like :q OR LOWER(p.emailAddress) like :q \
                 OR LOWER(p.note) like :q) AND ((p.birthYear >= :fromYear AND p.birthYear <= :toYear) OR p.birthYear = 0) \
                 AND a.block.id = :id \
                 order by p.firstNames, p.lastName, p.id',
                [ q:searchTerm, id:blockId, fromYear:fromYear, toYear:toYear ] )
        }

        log.info "Found ${peeps.size()} people"
        return peeps
    }
}
