package commongood

class AnswerController {
    static allowedMethods = [frequencies:'GET', saveInterview:'POST', saveTable:'POST']
    def authorizationService

    def frequencies( ) {
        def questionId = Long.parseLong( params.id )

        // Result is like [[biking,17],[dancing,4], ...]
        def freqs = Answer.executeQuery(
                'select a.text, count(a) as ca from Answer as a where a.question.id=? group by a.text order by ca desc',
                [questionId] )

        if( params.json ) {
            println 'Request for json freqs'
            def bldr = new groovy.json.JsonBuilder( freqs )
            def writer = new StringWriter()
            bldr.writeTo(writer)
            render writer
        } else {
            [ questionId:questionId, frequencies:freqs ]
        }
    }

    def get( ) {
        def answerId = Long.parseLong( params.id )
        authorizationService.answer( answerId, session )
        Answer answer = Answer.get( answerId )
        def result = [ id:answer.id, text:answer.text,
                wouldLead:answer.wouldLead, wouldOrganize:answer.wouldOrganize,
                question:answer.question.getLongHeader() ]

        def bldr = new groovy.json.JsonBuilder( result )
        def writer = new StringWriter()
        bldr.writeTo(writer)
        render writer
    }

    // TODO Remove saveTable once saveInterview is working
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
                    // TODO Replace failOnError with logic
                    answer.save( flush:true, failOnError: true )

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
                throw new Exception( "No answers!" )

            case 1:
                forward controller: "navigate", action: "familymember", id: lastPersonId

            default:
                forward controller: "navigate", action: "family", id: familyId
        }
    }

    // Will replace saveTable...
    def saveInterview( ) {
        /* Expecting parameters like this (for person 12 & 444, questions 34 & 36 (primary keys)):
                answer12_34=making+cookies\ngardening
                answer12_36=more+hootenannies\ntaller+trees\nmanna+from+heaven
                answer444_34=stamp+collecting
        where \n represents a single newline character
        */
        Long familyId = Long.parseLong( params.familyId )
        Family family = Family.get( familyId )

        Long lastPersonId = null
        def personCount = 0

        params.each{ param, value ->
            if(  value != null && value.size() > 0 && param.startsWith('answer') ) {
                def ids = param.substring(6).tokenize('_')
                Person person = Person.get( Long.parseLong( ids[0] ) )

                if( familyId != person.family.id ) {
                    println "DATA INTEGRITY ERROR! ${person} does not belong to ${family}"
                    throw new Exception( 'Bad bulk answers')
                }

                Question q = Question.get( Long.parseLong( ids[1] ) )
                
                // Multiple answers within this "answer" are separated by newline characters:
                def answers = value.tokenize( '\n' )
                answers.each {
                    // TODO test with weird answers (ex: nothing but newlines, padded with spaces)
                    Answer answer = new Answer( person:person, question:q, text:it,
                                wouldLead:Boolean.FALSE, wouldOrganize:Boolean.TRUE  )
                    // TODO Eiminate multiple flushes (would reduce calls to the db?)
                    // TODO Replace failOnError with logic
                    answer.save( flush:true, failOnError: true )

                    if( lastPersonId ) {
                        if( person.id != lastPersonId ) {
                            personCount++
                        }
                    } else {
                        personCount++
                    }
                    lastPersonId = person.id
                }
            }
        }

        family.interviewer = Person.get( Long.parseLong(params.interviewerId))
        family.interviewDate = new Date().parse( 'yyyy-MM-dd', params.interviewDate )

        family.participateInInterview = ('participateInInterview' in params)
        family.permissionToContact = ('permissionToContact' in params)
        family.save( flush:true, failOnError: true )

        if( personCount == 1 ) {
            forward controller: "navigate", action: "familymember", id: lastPersonId
        } else {
            forward controller: "navigate", action: "family", id: familyId
        }
    }
}
