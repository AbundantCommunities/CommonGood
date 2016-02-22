package commongood

import grails.transaction.Transactional

@Transactional
class SearchService {

    def answers( session, questionId, q ) {
        def neighbourhoodId = session.neighbourhood.id
        log.debug "Searching NH ${neighbourhoodId} answers for ${q}"
        def searchTerm = "%${q}%".toLowerCase( )
        def answers

        if( questionId > 0 ) {
            // Select only answers to that particular question
            answers = Answer.executeQuery(
                'select a.text, p.id, p.firstNames, p.lastName from Answer a join a.person p \
                 where lower(a.text) like ? and a.question.id = ? and p.family.address.block.neighbourhood.id = ? \
                 order by p.firstNames, p.lastName, p.id',
                [ searchTerm, questionId, neighbourhoodId ] )

        } else {
            // Select answers to all questions
            answers = Answer.executeQuery(
                'select a.text, p.id, p.firstNames, p.lastName from Answer a join a.person p \
                 where lower(a.text) like ? and p.family.address.block.neighbourhood.id = ? \
                 order by p.firstNames, p.lastName, p.id',
                [ searchTerm, neighbourhoodId ] )
        }

        log.debug "Found ${answers.size()} answers"
        return answers
    }

    def people( session, q ) {
        def neighbourhoodId = session.neighbourhood.id
        log.debug "Searching NH ${neighbourhoodId} people for ${q}"
        def searchTerm = "%${q}%".toLowerCase( )

        def peeps = Person.executeQuery(
            'select p.id, p.firstNames, p.lastName from Person p join p.family f join f.address a \
             where (lower(a.text) like ? or lower(a.note) like ? or lower(f.name) like ? or lower(f.note) like ? \
             or lower(p.firstNames) like ? or lower(p.lastName) like ? or lower(p.phoneNumber) like ? or lower(p.emailAddress) like ? \
             or lower(p.note) like ?) and a.block.neighbourhood.id = ? order by p.firstNames, p.lastName, p.id',
            ([ searchTerm ] * 9) << neighbourhoodId )

        log.debug "Found ${peeps.size()} people"
        return peeps
    }
}
