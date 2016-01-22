package commongood

import grails.transaction.Transactional

@Transactional
class SearchService {

    def answers( questionId, q ) {
        def searchTerm = "%${q}%".toLowerCase( )
        def answers

        // FIXME These searches examine answers from EVERY hood!
        if( questionId > 0 ) {
            // Select only answers to that particular question
            answers = Answer.executeQuery(
                'select a.text, p.id, p.firstNames, p.lastName from Answer a join a.person p where lower(a.text) like ? and a.question.id = ? \
                 order by p.firstNames, p.lastName, p.id',
                [ searchTerm, questionId ] )

        } else {
            // Select answers to all questions
            answers = Answer.executeQuery(
                'select a.text, p.id, p.firstNames, p.lastName from Answer a join a.person p where lower(a.text) like ? \
                 order by p.firstNames, p.lastName, p.id',
                [ searchTerm ] )
        }

        println "Found ${answers.size()} answers"
        return answers
    }

    def people( q ) {
        def searchTerm = "%${q}%".toLowerCase( )

        // FIXME These searches examine answers from EVERY hood!
        // Select only answers to that particular question
        def peeps = Person.executeQuery(
            'select p.id, p.firstNames, p.lastName from Person p join p.family f join f.address a \
             where lower(a.text) like ? or lower(a.note) like ? or lower(f.name) like ? or lower(f.note) like ? \
             or lower(p.firstNames) like ? or lower(p.lastName) like ? or lower(p.phoneNumber) like ? or lower(p.emailAddress) like ? \
             or lower(p.note) like ? order by p.firstNames, p.lastName, p.id',
            [ searchTerm ] * 9 )

        println "Found ${peeps.size()} people"
        return peeps
    }
}
