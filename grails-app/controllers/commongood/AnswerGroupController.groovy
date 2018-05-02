package commongood

class AnswerGroupController {
    def authorizationService
    def answerGroupService

    /*
     * Get the permutations for all ungrouped answers
     * (regardless of their question).
    */
    def index( ) {
        Neighbourhood neighbourhood= session.neighbourhood
        if( neighbourhood ) {
            // Yes, this is redundant, but let's follow the form
            // (authorization is such an important feature!)
            authorizationService.neighbourhoodRead( neighbourhood.id, session )
            def permutations = answerGroupService.neighbourhood( neighbourhood )
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
    def group() {
        Neighbourhood neighbourhood= session.neighbourhood
        if( neighbourhood ) {
            // Yes, this is redundant, but let's follow the form
            // (authorization is such an important feature!)
            authorizationService.neighbourhoodRead( neighbourhood.id, session )
            def answerKeys = [ ]
            params.keySet().each {
                if( it.startsWith("check") ) {
                    // the characters following "check" are the answer id
                    def answerId = it.substring(5)
                    answerKeys << Integer.valueOf( answerId )
                }
            }
            def answersAndGroups = answerGroupService.group( neighbourhood, answerKeys )
            [ result: answersAndGroups ]
        } else {
            // Looks like no one is logged in.
            throw new Exception( 'Authorization failure' )
        }
    }
}
