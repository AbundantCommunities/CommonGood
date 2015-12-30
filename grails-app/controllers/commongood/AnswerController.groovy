package commongood

class AnswerController {
    static allowedMethods = [index:'POST']

    def saveTable() {
        /* Expecting parameters like this (for person 12 & 444, questions 34 & 36 (primary keys)):
                answer12_34=making+cookies\ngardening
                answer12_36=more+hootenannies\ntaller+trees\nmanna+from+heaven
                answer444_34=stamp+collecting
        where \n represents a single newline character
        */
        params.each{ param, value ->
            if( param.startsWith('answer') ) {
                def ids = param.substring(6).tokenize('_')
                Person p = Person.get( Long.parseLong( ids[0] ) )
                Question q = Question.get( Long.parseLong( ids[1] ) )
                
                // Multiple answers within this "answer" are separated by newline characters:
                def answers = value.tokenize( '\n' )
                answers.each {
                    Answer answer = new Answer( person:p, question:q, text:it,
                                wouldLead:Boolean.FALSE, wouldOrganize:Boolean.TRUE  )
                    // TODO Eiminate multiple flushes (would reduce calls to the db?)
                    answer.save( flush:true )
                }
            }
        }
        render "To where should we navigate??"
    }
}
