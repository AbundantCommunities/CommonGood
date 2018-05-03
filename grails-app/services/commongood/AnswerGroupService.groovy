package commongood

import grails.transaction.Transactional

//@Transactional
class AnswerGroupService {

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
    private permuteText( text ) {
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

    /**
     * Get the neighbourhood's ungrouped answers as a permuted index.
     * 
     * Security Statement: we rely on the controller to ensure the user is
     * authorized to read any data owned by neighbourhood. We ensure the
     * questions we select belong to neighbourhood. We ensure the answers
     * we select belong to those questions. We ensure the people we select
     * belng to those answers.
     */
    def getUngroupedAnswers( Neighbourhood neighbourhood ) {
        def permutations = [ ]

        Answer.executeQuery(
            """SELECT a.id, a.text, q.shortText, p.firstNames, p.lastName
               FROM Answer a, Question q, Person p
               WHERE a.person = p AND a.question = q AND q.neighbourhood.id = ?
               AND a.answerGroup IS NULL""",
            [neighbourhood.id] ).each {

            def answerId = it[0]
            def answerText = it[1]
            def shortQuestion = it[2]
            def personName = it[3] + " " + it[4]

            permuteText( answerText ).each {
                // Each it is a permutation of answerText.
                // The fullLine dictionaries we create will be compared by comparePerms (below).
                def fullLine = [ answerId:answerId, permutedText:it, shortQuestion:shortQuestion, personName:personName ]
                permutations << fullLine
            }
        }

        // When sort compares two fillLine dictionaries it will use this closure
        Comparator comparePerms = { a, b -> a.permutedText == b.permutedText ? 0 : (a.permutedText < b.permutedText ? -1 : 1) }

        permutations.sort( comparePerms )
        return permutations
    }

    /**
     * answerIds is an ArrayList of Integer answer ids.
     * 
     * Security Statement: we rely on the controller to ensure the user is
     * authorized to read any data owned by neighbourhood. We ensure the
     * answers and answer groups we select belong to neighbourhood.
     * We ensure the people we select belong to the answers.
     */
    def getGroupsForAnswers( Neighbourhood neighbourhood, answerIds ) {

        // Transform the answerIds from a list to a string like
        // "1234,6677,101".
        String idsInString = ""
        answerIds.each{
            if( idsInString ) {
                idsInString = "${idsInString},${it}"
            } else {
                idsInString = "${it}"
            }
        }
        // Get the ungrouped answers the user has selected
        // Our QUERY PREVENTS selecting another neighbourhood's answers !!
        def answers = [ ]
        Answer.executeQuery(
            """SELECT a.id, a.text
               FROM Answer a
               WHERE a.question.neighbourhood.id = ?
               AND a.id IN (${idsInString})""",
            [neighbourhood.id] ).each {
                answers << [ id:it[0], text:it[1] ]
            }

        // Second, get all of the neighbourhood's AnswerGroups
        def groups = [ ]
        AnswerGroup.executeQuery(
            """SELECT id, name
               FROM AnswerGroup
               WHERE neighbourhood.id = ?
               ORDER BY name""",
            [neighbourhood.id] ).each {
                groups << [ id:it[0], name:it[1] ]
            }
        return [ answerIds:idsInString, answers:answers, groups:groups ]
    }

    /**
     * Assign answers to an AnswerGroup.
     * 
     * Security Statement: we rely on the controller to ensure the user is
     * authorized to read any data owned by neighbourhood. We ensure the
     * answers we update and the AnswerGroup we read belong to neighbourhood.
     */
    def putAnswersInGroup( Neighbourhood neighbourhood, Integer[] answerIds, Integer groupId ) {
        AnswerGroup group = AnswerGroup.get( groupId )
        if( group ) {
            if( group.neighbourhood.id==neighbourhood.id ) {
                answerIds.each{
                    Answer answer = Answer.get( it )
                    if( answer.question.neighbourhood.id == neighbourhood.id ) {
                        answer.answerGroup = group
                        answer.save( )
                    } else {
                        throw new Exception( "Authorization failure" )
                    }
                }
            } else {
                throw new Exception( "Authorization failure" )
            }
        } else {
            throw new Exception("Failed to retrieve AnswerGroup")
        }
    }
}
