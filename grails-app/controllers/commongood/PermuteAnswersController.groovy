package commongood

/**
 * Permute in the sense of "permuted index". For example, given the input text
 * 'learn to bake bread', the permutations are
 *    'learn to bake bread',
 *    'bake bread, learn to'
 *    'bread, learn to bake'
 * 
 * The logic knows to ignore words like 'to', 'and', 'a', etc.
*/
class PermuteAnswersController {
    def authorizationService
    def permuteService

    /*
     * Get the permutations for all answers, regardless of their question.
    */
    def index( ) {
        Neighbourhood neighbourhood= session.neighbourhood
        if( neighbourhood ) {
            // Yes, this is redundant, but let's follow the form
            // (authorization is such an important feature!)
            authorizationService.neighbourhoodRead( neighbourhood.id, session )
            def permutations = [ ]

            List answers = Answer.executeQuery( "SELECT text FROM Answer a WHERE a.question.neighbourhood.id = ?", [neighbourhood.id] ).each {
                permuteService.permute( it ).each {
                    if( !(it in permutations) ) {
                        permutations << it
                    }
                }
            }
            [ result: permutations.sort() ]
        } else {
            throw new Exception( 'Authorization failure' )
        }
    }

    /*
     * Get the permutations for the answers belonging to a given question.
    */
    def questionCode() {
        def questionId =  Long.valueOf( params.id )
        def neighbourhood = Question.get( questionId ).neighbourhood
        authorizationService.neighbourhoodRead( neighbourhood.id, session )

        def permutations = [ ]
        List answers = Answer.executeQuery( "select text from Answer a where a.question.id = ?", [questionId] ).each {
            permuteService.permute( it ).each {
                if( !(it in permutations) ) {
                    permutations << it
                }
            }
        }
        [ result: permutations.sort() ]
    }
}
