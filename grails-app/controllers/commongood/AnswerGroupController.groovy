package commongood

class AnswerGroupController {
    def authorizationService
    def answerGroupService

    /*
     * Get the permutations for all ungrouped answers
     * (regardless of their question).
    */
    def getUngroupedAnswers( ) {
        Neighbourhood neighbourhood= session.neighbourhood
        if( neighbourhood ) {
            // We are STRICT! Every call to an action should check in with
            // our authorization service.
            authorizationService.neighbourhoodRead( neighbourhood.id, session )
            def permutations = answerGroupService.getUngroupedAnswers( neighbourhood )
            [ result: permutations ]
        } else {
            // This is very bad. How did our filter allow this?
            throw new Exception( 'Authorization failure' )
        }
    }

    /*
     * Parameters like check1234, check4455, check88 mean the user wants to
     * place answers with keys 1234, 4455 and 88 into the same AnswerGroup.
     * (The way checkbox inputs work, non-checked items do not appear in params.)
    */
    def getGroupsForAnswers() {
        Neighbourhood neighbourhood= session.neighbourhood
        if( neighbourhood ) {
            // We are STRICT! Every call to an action should check in with
            // our authorization service.
            authorizationService.neighbourhoodRead( neighbourhood.id, session )
            def answerKeys = [ ]
            
            // One answer can appear many times in a permuted index.
            // The user may have selected the same answer more than once
            // but keySet() returns only unique values.
            // Also significant: only checked items are in params.
            params.keySet().each {
                // In our form, we appended answer id to "cha-"
                if( it.startsWith("cga-") ) {
                    // the characters following "check" are the answer id
                    answerKeys << Integer.valueOf( it.substring(4) )
                }
            }

            if( answerKeys ) {
                def answersAndGroups = answerGroupService.getGroupsForAnswers( neighbourhood, answerKeys )
                [ result: answersAndGroups ]
            } else {
                flash.message = "You did not select any answers"
                flash.nature = 'WARNING'
                redirect action:'getUngroupedAnswers'
            }
        } else {
            // This is very bad. How did our filter allow this?
            throw new Exception( 'Authorization failure' )
        }
    }

    def putAnswersInGroup() {
        Neighbourhood neighbourhood= session.neighbourhood
        if( neighbourhood ) {
            // We are STRICT! Every call to an action should check in with
            // our authorization service.
            authorizationService.neighbourhoodRead( neighbourhood.id, session )

            String[] answerIdStrings = params.answerIds.split(',')
            Integer groupId = params.int('groupId')

            Integer[] answerIds = [ ]
            answerIdStrings.each{
                answerIds += Integer.valueOf( it )
            }

            if( answerIds.size() ) {
                answerGroupService.putAnswersInGroup( neighbourhood, answerIds, groupId )
                flash.message = "We put ${answerIds.size()} answers in the group you selected"
                flash.nature = 'SUCCESS'
                redirect action: 'getUngroupedAnswers'
            } else {
                // This should not have gotten this far with zero answers selected
                throw new Exception( 'No answers to group?!' )
            }
        } else {
            // This is very bad. How did our filter allow this?
            throw new Exception( 'Authorization failure' )
        }
    }
}
