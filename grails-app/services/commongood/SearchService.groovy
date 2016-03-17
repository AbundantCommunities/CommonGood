package commongood

import grails.transaction.Transactional

@Transactional
class SearchService {

    def answers( session, q ) {
        def searchTerm = "%${q}%".toLowerCase( )
        def answers

        if( session.authorized.forNeighbourhood() ) {
            def neighbourhoodId = session.neighbourhood.id
            log.info "${session.user.logName} searching neighbourhood ${neighbourhoodId} answers for ${q}"
            answers = Answer.executeQuery(
                'SELECT ans.text, ans.wouldAssist, p.id, p.firstNames, p.lastName, q.shortText \
                 from Answer ans, Person p, Question q \
                 where LOWER(ans.text) like ? \
                 AND ans.person.id = p.id \
                 AND ans.question.id = q.id \
                 AND q.neighbourhood.id = ? \
                 ORDER BY p.firstNames, p.lastName, p.id',
                [ searchTerm, neighbourhoodId ])
        } else {
            def blockId = session.block.id
            log.info "${session.user.logName} searching block ${blockId} answers for ${q}"
            answers = Answer.executeQuery(
                'SELECT ans.text, ans.wouldAssist, p.id, p.firstNames, p.lastName, q.shortText \
                 FROM Answer ans, Person p, Family f, Address addr, Question q \
                 WHERE LOWER(ans.text) LIKE ? \
                 AND ans.person.id = p.id \
                 AND ans.question.id = q.id \
                 AND p.family.id = f.id \
                 AND f.address.id = addr.id \
                 AND addr.block.id = ? \
                 ORDER BY p.firstNames, p.lastName, p.id',
                [ searchTerm, blockId ])
        }

        log.info "Found ${answers.size()} answers"
        return answers
    }

    def answersWithContactInfo( session, q ) {
        def searchTerm = "%${q}%".toLowerCase( )
        def answers

        if( session.authorized.forNeighbourhood() ) {
            def neighbourhoodId = session.neighbourhood.id
            log.info "${session.user.logName} searching neighbourhood ${neighbourhoodId} answers for ${q} (with contact info)"

            answers = Answer.executeQuery(
                'SELECT ans.text, ans.wouldAssist, p.id, p.firstNames, p.lastName, q.shortText, \
                 p.phoneNumber, p.emailAddress, addr.text \
                 FROM Answer ans, Person p, Family f, Address addr, Question q \
                 WHERE LOWER(ans.text) like ? \
                 AND ans.person.id = p.id \
                 AND ans.question.id = q.id \
                 AND q.neighbourhood.id = ? \
                 AND p.family.id = f.id \
                 AND f.address.id = addr.id \
                 ORDER BY p.firstNames, p.lastName, p.id',
                [ searchTerm, neighbourhoodId ])
        } else {
            def blockId = session.block.id
            log.info "${session.user.logName} searching block ${blockId} answers for ${q} (with contact info)"

            answers = Answer.executeQuery(
                'SELECT ans.text, ans.wouldAssist, p.id, p.firstNames, p.lastName, q.shortText, \
                 p.phoneNumber, p.emailAddress, addr.text \
                 FROM Answer ans, Person p, Family f, Address addr, Question q \
                 WHERE LOWER(ans.text) like ? \
                 AND ans.person.id = p.id \
                 AND ans.question.id = q.id \
                 AND p.family.id = f.id \
                 AND f.address.id = addr.id \
                 AND addr.block.id = ? \
                 ORDER BY p.firstNames, p.lastName, p.id',
                [ searchTerm, blockId ])
        }

        log.info "Found ${answers.size()} answers"
        return answers
    }

    def people( session, q ) {
        def searchTerm = "%${q}%".toLowerCase( )
        def peeps

        if( session.authorized.forNeighbourhood() ) {
            def neighbourhoodId = session.neighbourhood.id
            log.info "${session.user.logName} searching neighbourhood ${neighbourhoodId} people for ${q}"

            peeps = Person.executeQuery(
            'select p.id, p.firstNames, p.lastName \
             from Person p join p.family f join f.address a \
             where (lower(a.text) like ? or lower(a.note) like ? or lower(f.name) like ? or lower(f.note) like ? \
             or lower(p.firstNames) like ? or lower(p.lastName) like ? or lower(p.phoneNumber) like ? or lower(p.emailAddress) like ? \
             or lower(p.note) like ?) and a.block.neighbourhood.id = ? order by p.firstNames, p.lastName, p.id',
            ([ searchTerm ] * 9) << neighbourhoodId )

        } else {
            def blockId = session.block.id
            log.info "${session.user.logName} searching block ${blockId} people for ${q}"

            peeps = Person.executeQuery(
            'select p.id, p.firstNames, p.lastName \
             from Person p join p.family f join f.address a \
             where (lower(a.text) like ? or lower(a.note) like ? or lower(f.name) like ? or lower(f.note) like ? \
             or lower(p.firstNames) like ? or lower(p.lastName) like ? or lower(p.phoneNumber) like ? or lower(p.emailAddress) like ? \
             or lower(p.note) like ?) \
             and a.block.id = ? \
             order by p.firstNames, p.lastName, p.id',
            ([ searchTerm ] * 9) << blockId )
        }

        log.info "Found ${peeps.size()} people"
        return peeps
    }

    def peopleWithContactInfo( session, q ) {
        def searchTerm = "%${q}%".toLowerCase( )
        def peeps

        if( session.authorized.forNeighbourhood() ) {
            def neighbourhoodId = session.neighbourhood.id
            log.info "Searching NH ${neighbourhoodId} people for ${q} (with contact info)"

            peeps = Person.executeQuery(
                'select p.id, p.firstNames, p.lastName, p.phoneNumber, p.emailAddress, a.text \
                 from Person p join p.family f join f.address a \
                 where (LOWER(a.text) like ? OR LOWER(a.note) like ? OR LOWER(f.name) like ? OR LOWER(f.note) like ? \
                 OR LOWER(p.firstNames) like ? OR LOWER(p.lastName) like ? OR LOWER(p.phoneNumber) like ? OR LOWER(p.emailAddress) like ? \
                 OR LOWER(p.note) like ?) and a.block.neighbourhood.id = ? order by p.firstNames, p.lastName, p.id',
                ([ searchTerm ] * 9) << neighbourhoodId )
        } else {
            def blockId = session.block.id
            log.info "Searching block ${blockId} people for ${q} (with contact info)"

            peeps = Person.executeQuery(
                'select p.id, p.firstNames, p.lastName, p.phoneNumber, p.emailAddress, a.text \
                 from Person p join p.family f join f.address a \
                 where (LOWER(a.text) like ? OR LOWER(a.note) like ? OR LOWER(f.name) like ? OR LOWER(f.note) like ? \
                 OR LOWER(p.firstNames) like ? OR LOWER(p.lastName) like ? OR LOWER(p.phoneNumber) like ? OR LOWER(p.emailAddress) like ? \
                 OR LOWER(p.note) like ?) \
                 AND a.block.id = ? \
                 order by p.firstNames, p.lastName, p.id',
                ([ searchTerm ] * 9) << blockId )
        }

        log.info "Found ${peeps.size()} people"
        return peeps
    }
}
