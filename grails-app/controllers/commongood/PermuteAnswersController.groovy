package commongood

/**
 * Permute in the sense of "permuted index". For example, given the input text
 * 'learn to bake bread', the permutations are
 * 'learn to bake bread',
 * 'bake bread, learn to'
 * 'bread, learn to bake'
 * 
 * The logic knows to ignore words like 'to', 'and', 'a', etc.
*/
class PermuteAnswersController {
    def authorizationService

    def tooCommon = ['a', 'and', 'as', 'at', 'by', 'fewer', 'for', 'in', 'is',\
            'less', 'like', 'more', 'no', 'of', 'on', 'or', 'out', 'the', 'to', 'with']

    // TODO does 'no discord' work sensibly??
    def permute( text ) {
        text = text.toLowerCase( )
        def words = text.tokenize(' ')
        if( words.size() == 1 ) {
            return words
        } else {
            // FIXME Mistake to always include unpermuted text in permutations
            // Example: 'the best parks' makes an entry stating with 'the'
            def permutations = [ text ]
            def lastWord = words.size( ) - 1
            for( i in 1..lastWord ) {
                def word = words[i]
                if( tooCommon.find{it==word} ) {
                    // this word is too common, so skip it
                } else {
                    //this is not a common word, so make a new entry
                    permutations << words[ i..lastWord ].join(' ') +
                        ', ' + words[ 0..(i-1)].join(' ')
                }
            }
            return permutations
        }
    }
    
    def questionCode() {
        def questionId =  Long.valueOf( params.id )
        def neighbourhood = Question.get( questionId ).neighbourhood
        authorizationService.neighbourhood( neighbourhood.id, session )

        def permutations = [ ]
        List answers = Answer.executeQuery( "select text from Answer a where a.question.id = ?", [questionId] ).each {
            permute( it ).each {
                if( !(it in permutations) ) {
                    permutations << it
                }
            }
        }
        [result: permutations.sort( )]
    }
}
