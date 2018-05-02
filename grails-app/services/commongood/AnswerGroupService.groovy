package commongood

import grails.transaction.Transactional

//@Transactional
class PermuteService {

    def tooCommon = ['a', 'and', 'as', 'at', 'by', 'fewer', 'for', 'in', 'is',
            'less', 'like', 'more', 'no', 'of', 'on', 'or', 'out', 'the', 'to', 'with']

    /**
     * Permute in the sense of "permuted index". For example, given the input text
     * 'learn to bake bread', the permutations are
     *    'learn to bake bread',
     *    'bake bread, learn to'
     *    'bread, learn to bake'
     * 
     * The logic knows to ignore words like 'to', 'and', 'a', etc.
    */
    def permuteText( text ) {
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

    def neighbourhood( Neighbourhood neighbourhood ) {
        def permutations = [ ]

        List answers = Answer.executeQuery(
                """SELECT a.id, a.text, q.shortText, p.firstNames, p.lastName
                   FROM Answer a, Question q, Person p
                   WHERE a.question.neighbourhood.id = ? AND a.person = p AND a.question = q
                   AND a.answerGroup IS NULL""",
                [neighbourhood.id] ).each {

                def answerId = it[0]
                def answerText = it[1]
                def shortQuestion = it[2]
                def personName = it[3] + " " + it[4]

                permuteText( answerText ).each {
                    // The fullLine dictionaries we create will be compared by comparePerms (below)
                    def fullLine = [ answerId:answerId, permutedText:it, shortQuestion:shortQuestion, personName:personName ]
                    permutations << fullLine
                }
        }

        // When sort compare two fillLine dictionaries...
        Comparator comparePerms = { a, b -> a.permutedText == b.permutedText ? 0 : (a.permutedText < b.permutedText ? -1 : 1) }

        permutations.sort( comparePerms )
        return permutations
    }
    
    def group( answerIds ) {
        println "User wants answers ${answerIds} in the same group"
    }
}
