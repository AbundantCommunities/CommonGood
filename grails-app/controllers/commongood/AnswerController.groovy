package commongood

import org.abundantcommunityinitiative.commongood.handy.JsonWriter

class AnswerController {
    static allowedMethods = [frequencies:'GET', get:'GET', save:'POST', saveInterview:'POST']
    def authorizationService

    def frequencies( ) {
        def questionId = Long.parseLong( params.id )
        if( params.json ) {
            log.info "Anon requests Answer Ranking question/${questionId}"
        } else {
            log.info "${session.user.getFullName()} requests Answer Ranking question/${questionId}"
        }
        def question = Question.get( questionId )

        // Result is like [[biking,17],[dancing,4], ...]
        def freqs = Answer.executeQuery(
                'select lower(a.text), count(a) as ca from Answer as a where a.question.id=:qId group by lower(a.text) order by ca desc',
                [qId:questionId] )

        if( params.json ) {
            render JsonWriter.write( freqs )
        } else {
            [ question:question, frequencies:freqs ]
        }
    }

    def delete( ) {
        def answerId = Long.parseLong( params.id )
        log.info "${session.user.getFullName()} requests delete answer/${answerId}"
        authorizationService.answer( answerId, session )
        def answer = Answer.get( answerId )
        def person = answer.person
        answer.delete(flush: true)
        forward controller:'navigate', action:'familymember', id:person.id
    }

    // Get one answer as JSON
    def get( ) {
        def answerId = Long.parseLong( params.id )
        log.info "${session.user.getFullName()} requests get answer/${answerId}"
        authorizationService.answer( answerId, session )
        Answer answer = Answer.get( answerId )
        def result = [ id: answer.id, text: answer.text,
                wouldAssist: answer.wouldAssist,
                note: answer.note,
                question: answer.question.getLongHeader() ]

        render JsonWriter.write( result )
    }

    // Save changes to one answer
    def save( ) {
        def answerId =  params.long('id')
        log.info "${session.user.getFullName()} save answer/${answerId}"
        authorizationService.answer( answerId, session )
        Answer answer = Answer.get( answerId )
        answer.text = params.text
        answer.wouldAssist = ('wouldAssist' in params)
        answer.note = params.note
        answer.save( flush:true, failOnError: true )
        redirect controller:'navigate', action:'familymember', id:answer.person.id
    }

    // Save a famiy's interview data (changes 2 tables: family & answer)
    def saveInterview( ) {
        /* Expecting parameters like this (for person 12 & 444, questions 34 & 36 (primary keys)):
                answer12_34=making+cookies\ngardening
                answer12_36=more+hootenannies\ntaller+trees\nmanna+from+heaven
                answer444_34=stamp+collecting
        where \n represents a single newline character
        */
        Long familyId = Long.parseLong( params.familyId )
        log.info "${session.user.getFullName()} requests save interview for family/${familyId}"
        authorizationService.family( familyId, session )
        Family family = Family.get( familyId )

        params.each{ param, value ->
            if( param.startsWith('answer') && value ) {
                def ids = param.substring(6).tokenize('_')
                Person person = Person.get( Long.parseLong( ids[0] ) )

                if( familyId != person.family.id ) {
                    log.warn "DATA INTEGRITY ERROR! ${person} does not belong to ${family}"
                    throw new Exception( 'Bad bulk answers')
                }

                // TODO How to treat question id does not belong to this NH
                Question q = Question.get( Long.parseLong( ids[1] ) )
                
                // Multiple answers within this "answer" are separated by newline characters:
                def answers = value.tokenize( '\n' )
                answers.each {
                    // TODO test with weird answers (ex: nothing but newlines, padded with spaces)
                    // Use Java regular expression to remove "control" characters
                    def cleanAnswer = it.replaceAll("\\p{Cntrl}", "").trim( )
                    if( cleanAnswer ) {
                        Answer answer = new Answer( person:person, question:q, text:cleanAnswer, note:'?',
                                    wouldAssist:Boolean.FALSE)
                        // TODO Eiminate multiple flushes (would reduce calls to the db?)
                        // TODO Replace failOnError with logic
                        answer.save( flush:true, failOnError: true )
                    }
                }
            }
        }

        family.interviewer = Person.get( Long.parseLong(params.interviewerId))
        family.interviewDate = new Date().parse( 'yyyy-MM-dd', params.interviewDate )

        family.participateInInterview = ('participateInInterview' in params)
        family.permissionToContact = ('permissionToContact' in params)
        family.save( flush:true, failOnError: true )

        forward controller: "navigate", action: "family", id: familyId
    }
}
