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

    def questionCode() {
        def questionId =  Long.valueOf( params.id )
        def neighbourhood = Question.get( questionId ).neighbourhood
        authorizationService.neighbourhood( neighbourhood.id, session )

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
