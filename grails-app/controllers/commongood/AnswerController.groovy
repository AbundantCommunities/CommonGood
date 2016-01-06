package commongood

class AnswerController {
    static allowedMethods = [frequencies:'GET', saveTable:'POST', search:'GET']

    def search( ) {
        def questionId = params.id ? Long.parseLong( params.id ) : 0
        def searchTerm = "%${params.q}%"
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
            questionText = null
        }

        [ questionId:questionId, answers:answers, q:params.q, questionText:questionText ]
    }

    def frequencies( ) {
        def questionId = Long.parseLong( params.id )

        // Result is like [[biking,17],[dancing,4], ...]
        def freqs = Answer.executeQuery(
                'select a.text, count(a) as ca from Answer as a where a.question.id=? group by a.text order by ca desc',
                [questionId] )
        
        [ questionId:questionId, frequencies:freqs ]
    }

    def saveTable( ) {
        /* Expecting parameters like this (for person 12 & 444, questions 34 & 36 (primary keys)):
                answer12_34=making+cookies\ngardening
                answer12_36=more+hootenannies\ntaller+trees\nmanna+from+heaven
                answer444_34=stamp+collecting
        where \n represents a single newline character
        */

        // We want every person to come from the same family
        Long familyId = null
        Long lastPersonId = null
        def personCount = 0

        params.each{ param, value ->
            if(  value != null && value.size() > 0 && param.startsWith('answer') ) {
                def ids = param.substring(6).tokenize('_')
                Person p = Person.get( Long.parseLong( ids[0] ) )
                if( familyId ) {
                    // This is not the first answer we have processed
                    if( familyId != p.family.id ) {
                        println "DATA INTEGRITY ERROR? Was family ${familyId} but saw person ${p.id}"
                        throw new Exception( 'Bad bulk answers')
                    }
                } else {
                    familyId = p.family.id
                }

                Question q = Question.get( Long.parseLong( ids[1] ) )
                
                // Multiple answers within this "answer" are separated by newline characters:
                def answers = value.tokenize( '\n' )
                answers.each {
                    // TODO test with weird answers (ex: nothing but newlines, padded with spaces)
                    Answer answer = new Answer( person:p, question:q, text:it,
                                wouldLead:Boolean.FALSE, wouldOrganize:Boolean.TRUE  )
                    // TODO Eiminate multiple flushes (would reduce calls to the db?)
                    answer.save( flush:true )

                    if( lastPersonId ) {
                        if( p.id != lastPersonId ) {
                            personCount++
                        }
                    } else {
                        personCount++
                    }
                    lastPersonId = p.id
                }
            }
        }
        
        switch( personCount ) {
            case 0:
                // FIXME Handle zero answers
                // ...we don't handle zero-length answers so don't know any person or family ids
                throw new Exception( "yikes... what to do, what to do!!?" )

            case 1:
                forward controller: "navigate", action: "familymember", id: lastPersonId

            default:
                forward controller: "navigate", action: "family", id: familyId
        }
    }
}
