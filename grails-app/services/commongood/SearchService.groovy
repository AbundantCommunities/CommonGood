package commongood

import grails.transaction.Transactional

@Transactional
class SearchService {

    def answers( questionId, q ) {
        def searchTerm = "%${q}%"
        def questionText
        def answers

        // FIXME These searches examine answers from EVERY hood!
        if( questionId > 0 ) {
            // Select only answers to that particular question
            answers = Answer.executeQuery(
                'select a.text, p.id, p.firstNames from Answer a join a.person p where a.text like ? and a.question.id = ? \
                 order by p.firstNames, p.lastName, p.id',
                [ searchTerm, questionId ] )

            questionText = Question.get( questionId ).text

        } else {
            // Select answers to all questions
            answers = Answer.executeQuery(
                'select a.text, p.id, p.firstNames from Answer a join a.person p where a.text like ? \
                 order by p.firstNames, p.lastName, p.id',
                [ searchTerm ] )

            questionText = '<All questions>'
        }

        println "Found ${answers.size()} answers"
        return answers
    }

    def people( q ) {
        def searchTerm = "%${q}%"

        // FIXME These searches examine answers from EVERY hood!
        // Select only answers to that particular question
        def peeps = Person.executeQuery(
            'select p.id, p.firstNames, p.lastName from Person p join p.family f join f.address a \
             where a.text like ? or a.note like ? or f.name like ? or f.note like ? \
             or p.firstNames like ? or p.lastName like ? or p.phoneNumber like ? or p.emailAddress like ? \
             or p.note like ? order by p.firstNames, p.lastName, p.id',
            [ searchTerm ] * 9 )

        println "Found ${peeps.size()} people"
        return peeps
    }
}
