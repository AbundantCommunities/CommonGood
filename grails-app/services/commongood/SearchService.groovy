package commongood

import grails.transaction.Transactional

@Transactional
class SearchService {

    def answers( session, q ) {
        def neighbourhoodId = session.neighbourhood.id
        log.debug "Searching NH ${neighbourhoodId} answers for ${q}"
        def searchTerm = "%${q}%".toLowerCase( )
        def answers

        answers = Answer.executeQuery(
            'select a.text, a.wouldLead, a.wouldOrganize, p.id, p.firstNames, p.lastName, q.shortText \
             from Answer a, Person p, Question q \
             where lower(a.text) like ? \
             AND a.person.id = p.id \
             AND a.question.id = q.id \
             AND q.neighbourhood.id = ? \
             ORDER BY p.firstNames, p.lastName, p.id',
            [ searchTerm, neighbourhoodId ])

        log.debug "Found ${answers.size()} answers"
        return answers
    }

    def answersWithContactInfo( session, q ) {
        def neighbourhoodId = session.neighbourhood.id
        log.debug "Searching NH ${neighbourhoodId} answers for ${q}"
        def searchTerm = "%${q}%".toLowerCase( )
        def answers

        answers = Answer.executeQuery(
            'select ans.text, ans.wouldLead, ans.wouldOrganize, p.id, p.firstNames, p.lastName, q.shortText, \
             p.phoneNumber, p.emailAddress, addr.text \
             from Answer ans, Person p, Family f, Address addr, Question q \
             where lower(ans.text) like ? \
             AND ans.person.id = p.id \
             AND ans.question.id = q.id \
             AND q.neighbourhood.id = ? \
             AND p.family.id = f.id \
             AND f.address.id = addr.id \
             ORDER BY p.firstNames, p.lastName, p.id',
            [ searchTerm, neighbourhoodId ])

        log.debug "Found ${answers.size()} answers"
        return answers
    }

    def people( session, q ) {
        def neighbourhoodId = session.neighbourhood.id
        log.debug "Searching NH ${neighbourhoodId} people for ${q}"
        def searchTerm = "%${q}%".toLowerCase( )

        def peeps = Person.executeQuery(
            'select p.id, p.firstNames, p.lastName \
             from Person p join p.family f join f.address a \
             where (lower(a.text) like ? or lower(a.note) like ? or lower(f.name) like ? or lower(f.note) like ? \
             or lower(p.firstNames) like ? or lower(p.lastName) like ? or lower(p.phoneNumber) like ? or lower(p.emailAddress) like ? \
             or lower(p.note) like ?) and a.block.neighbourhood.id = ? order by p.firstNames, p.lastName, p.id',
            ([ searchTerm ] * 9) << neighbourhoodId )

        log.debug "Found ${peeps.size()} people"
        return peeps
    }

    def peopleWithContactInfo( session, q ) {
        def neighbourhoodId = session.neighbourhood.id
        log.debug "Searching NH ${neighbourhoodId} people for ${q}"
        def searchTerm = "%${q}%".toLowerCase( )

        def peeps = Person.executeQuery(
            'select p.id, p.firstNames, p.lastName, p.phoneNumber, p.emailAddress, a.text \
             from Person p join p.family f join f.address a \
             where (lower(a.text) like ? or lower(a.note) like ? or lower(f.name) like ? or lower(f.note) like ? \
             or lower(p.firstNames) like ? or lower(p.lastName) like ? or lower(p.phoneNumber) like ? or lower(p.emailAddress) like ? \
             or lower(p.note) like ?) and a.block.neighbourhood.id = ? order by p.firstNames, p.lastName, p.id',
            ([ searchTerm ] * 9) << neighbourhoodId )

        log.debug "Found ${peeps.size()} people"
        return peeps
    }
}
