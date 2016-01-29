package commongood

class AnswerController {
    static allowedMethods = [frequencies:'GET', get:'GET', save:'POST', saveInterview:'POST']
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

    def delete( ) {
        def answerId = Long.parseLong( params.id )
        authorizationService.answer( answerId, session )
        def answer = Answer.get( answerId )
        def person = answer.person
        answer.delete(flush: true)
        forward controller:'navigate', action:'familymember', id:person.id
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

    def save( ) {
        def answerId =  params.long('id')
        authorizationService.answer( answerId, session )
        Answer answer = Answer.get( answerId )
        answer.text = params.text
        answer.wouldLead = ('wouldLead' in params)
        answer.wouldOrganize = ('wouldOrganize' in params)
        answer.save( flush:true, failOnError: true )
        forward controller:'navigate', action:'familymember', id:answer.person.id
    }

    def saveInterview( ) {
        /* Expecting parameters like this (for person 12 & 444, questions 34 & 36 (primary keys)):
                answer12_34=making+cookies\ngardening
                answer12_36=more+hootenannies\ntaller+trees\nmanna+from+heaven
                answer444_34=stamp+collecting
        where \n represents a single newline character
        */
        Long familyId = Long.parseLong( params.familyId )
        Family family = Family.get( familyId )

        params.each{ param, value ->
            if( param.startsWith('answer') && value ) {
                def ids = param.substring(6).tokenize('_')
                Person person = Person.get( Long.parseLong( ids[0] ) )

                if( familyId != person.family.id ) {
                    println "DATA INTEGRITY ERROR! ${person} does not belong to ${family}"
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
                        Answer answer = new Answer( person:person, question:q, text:cleanAnswer,
                                    wouldLead:Boolean.FALSE, wouldOrganize:Boolean.FALSE  )
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
    
    def search( ) {
        // TODO call the search service (so that a GSP can search just answers!)
    }
}
