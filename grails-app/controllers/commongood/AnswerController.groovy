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

        // We want every person to come from the same family
        Long thisFamilyId = null

        params.each{ param, value ->
            if( param.startsWith('answer') ) {
                def ids = param.substring(6).tokenize('_')
                Person p = Person.get( Long.parseLong( ids[0] ) )
                if( thisFamilyId ) {
                    // This is not the first answer we have processed
                    if( thisFamilyId != p.family.id ) {
                        println "DATA INTEGRITY ERROR? Was family ${thisFamilyId} but saw person ${p.id}"
                        throw new Exception( 'Bad bulk answers')
                    }
                } else {
                    thisFamilyId = p.family.id
                }
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
        forward controller: "navigate", action: "family", id: thisFamilyId
    }
}
