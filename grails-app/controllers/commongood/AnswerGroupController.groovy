package commongood

import org.abundantcommunityinitiative.commongood.handy.UnneighbourlyException

class AnswerGroupController {
    def authorizationService
    def answerGroupService

    def index( ) {
        Neighbourhood neighbourhood= session.neighbourhood
        if( neighbourhood ) {
            // We are STRICT! Every call to an action should check in with
            // our authorization service.
            authorizationService.neighbourhoodRead( neighbourhood.id, session )
            log.info("Get answer groups for ${neighbourhood}")

            def groups = answerGroupService.getGroups( neighbourhood )
            [ result: groups ]
        } else {
            // This is very bad. How did our filter allow this?
            throw new UnneighbourlyException( )
        }
    }

    /*
     * Get the permutations for all ungrouped answers, regardless of question.
     *
     * Security Statement: we ensure the user is authorized to read the
     * neighbourhood's data. We rely on answerGroupService to select only
     * answers, questions and people that belong to neighbourhood.
     */
    def getUngroupedAnswers( ) {
        Neighbourhood neighbourhood= session.neighbourhood
        if( neighbourhood ) {
            // We are STRICT! Every call to an action should check in with
            // our authorization service.
            authorizationService.neighbourhoodRead( neighbourhood.id, session )
            log.info("Get ungrouped answers for ${neighbourhood}")

            def permutations = answerGroupService.getUngroupedAnswers( neighbourhood )
            [ result: permutations ]
        } else {
            // This is very bad. How did our filter allow this?
            throw new UnneighbourlyException( )
        }
    }

    /*
     * Parameters like cga-1234, cga-4455, cga-88 mean the user wants to
     * place answers with keys 1234, 4455 and 88 into an AnswerGroup they will choose.
     * (The way checkbox inputs work, non-checked items do not appear in params.)
     * 
     * Security Statement: we ensure the user is authorized to read the
     * neighbourhood's data. We rely on answerGroupService to select only
     * answers and answer groups that belong to neighbourhood.
    */
    def getGroupsForAnswers() {
        Neighbourhood neighbourhood= session.neighbourhood
        if( neighbourhood ) {
            // We are STRICT! Every call to an action should check in with
            // our authorization service.
            authorizationService.neighbourhoodRead( neighbourhood.id, session )
            log.info("Get all groups for chosen answers for ${neighbourhood}")
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
            throw new UnneighbourlyException( )
        }
    }

    /*
     * Parameter answerIds is a string listing answer ids, like "123,5566,42".
     * 
     * Either groupId is defined (the id of the AnswerGroup into which the
     * answers should be placed) or newGroupName is defined (make a new AnswerGroup
     * and place the answers into it).
     * 
     * Security Statement: we ensure the user is authorized to read the
     * neighbourhood's data. We rely on answerGroupService to ensure the answer
     * ids and the AnswerGroup belongs to neighbourhood.
    */
    def putAnswersInGroup() {
        Neighbourhood neighbourhood= session.neighbourhood
        if( neighbourhood ) {
            // We are STRICT! Every call to an action should check in with
            // our authorization service.
            authorizationService.neighbourhoodRead( neighbourhood.id, session )

            String[] answerIdStrings = params.answerIds.split(',')
            Integer[] answerIds = [ ]
            answerIdStrings.each{
                answerIds += Integer.valueOf( it )
            }

            if( answerIds.size() == 0 ) {
                // Should not have gotten this far with zero answers selected
                throw new RuntimeException( 'No answers to group' )
            }

            Integer groupId = params.int('groupId')
            String newGroupName = params.newGroupName

            if( groupId ) {
                if( newGroupName ) {
                    throw new Exception("Both an existing group and a new group")
                } else {
                    log.info "Add answers ${answerIdStrings} to existing group ${groupId}"
                    answerGroupService.putAnswersInOldGroup( neighbourhood, answerIds, groupId )
                    flash.message = "We put ${answerIds.size()} answers in the group you selected"
                    flash.nature = 'SUCCESS'
                    redirect action: 'getUngroupedAnswers'
                }
            } else {
                if( newGroupName ) {
                    log.info "Add answers $answerIdStrings to new group ${newGroupName}"
                    answerGroupService.putAnswersInNewGroup( neighbourhood, answerIds, newGroupName )
                    flash.message = "We put ${answerIds.size()} answers in new group ${newGroupName}"
                    flash.nature = 'SUCCESS'
                    redirect action: 'getUngroupedAnswers'
                } else {
                    throw new Exception("Neither an existing group nor a new group")
                }
            }
        } else {
            // This is very bad. How did our filter allow this?
            throw new UnneighbourlyException( )
        }
    }

    def getAnswers( ) {
        Neighbourhood neighbourhood= session.neighbourhood
        if( neighbourhood ) {
            // We are STRICT! Every call to an action should check in with
            // our authorization service.
            authorizationService.neighbourhoodRead( neighbourhood.id, session )
            Long groupId = params.long('id')
            log.info("Get answers belonging to answer Ggroup ${groupId}")

            def answers = answerGroupService.getAnswers( neighbourhood, groupId )
            [ result: answers ]
        } else {
            // This is very bad. How did our filter allow this?
            throw new UnneighbourlyException( )
        }
    }
}
