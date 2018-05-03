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
            // Yes, this is redundant, but let's follow the form
            // (authorization is such an important feature!)
            authorizationService.neighbourhoodRead( neighbourhood.id, session )
            def permutations = answerGroupService.getUngroupedAnswers( neighbourhood )
            [ result: permutations ]
        } else {
            // Looks like no one is logged in.
            throw new Exception( 'Authorization failure' )
        }
    }

    /*
     * Parameters like check1234, check4455, check88 mean the user wants to
     * place answers with keys 1234, 4455 and 88 into the same AnswerGroup.
    */
    def getGroupsForAnswers() {
        Neighbourhood neighbourhood= session.neighbourhood
        if( neighbourhood ) {
            // Yes, this is redundant, but let's follow the form
            // (authorization is such an important feature!)
            authorizationService.neighbourhoodRead( neighbourhood.id, session )
            def answerKeys = [ ]
            
            // One answer can appear many times in a permuted index.
            // The user may have selected the same answer more than once
            // but keySet() returns only unique values.
            params.keySet().each {
                if( it.startsWith("check") ) {
                    // the characters following "check" are the answer id
                    answerKeys << Integer.valueOf( it.substring(5) )
                }
            }
            if( answerKeys ) {
                def answersAndGroups = answerGroupService.getGroupsForAnswers( neighbourhood, answerKeys )
                [ result: answersAndGroups ]
            } else {
                throw new Exception("Should flash yellow: no answers selected")
            }
        } else {
            // Looks like no one is logged in.
            throw new Exception( 'Authorization failure' )
        }
    }

    def putAnswersInGroup() {
        Neighbourhood neighbourhood= session.neighbourhood
        if( neighbourhood ) {
            // We are STRICT! Every call to an action should check in with
            // our authorization service.
            authorizationService.neighbourhoodRead( neighbourhood.id, session )

            String[] answerIds = params.answerIds.split(',')
            Integer groupId = params.int('groupId')

            Integer[] answerKeys = [ ]
            answerIds.each{
                answerKeys += Integer.valueOf(it)
            }

            answerGroupService.putAnswersInGroup( neighbourhood, answerKeys, groupId )
            redirect action: 'getUngroupedAnswers'
        } else {
            // Looks like no one is logged in.
            throw new Exception( 'Authorization failure' )
        }
    }
}
