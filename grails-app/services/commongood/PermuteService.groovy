package commongood

import grails.transaction.Transactional

//@Transactional
class PermuteService {

    def tooCommon = ['a', 'and', 'as', 'at', 'by', 'fewer', 'for', 'in', 'is',
            'less', 'like', 'more', 'no', 'of', 'on', 'or', 'out', 'the', 'to', 'with']

    def permute( text ) {
        text = text.toLowerCase( )
        def words = text.tokenize(' ')

        if( words.size() <= 1 ) {
            return words
        } else {
            def permutations  // this will be the result

            // The first permutation is a special case
            if( words[0] in tooCommon ) {
                // ex: 'the best place' begins with a common word
                // so we'll discard this permutation
                permutations = [ ]
            } else {
                // Our 1st permutation will be the unaltered input text
                permutations = [ text ]
            }

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
}
