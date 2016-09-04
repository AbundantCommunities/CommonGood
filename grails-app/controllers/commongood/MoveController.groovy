package commongood

import org.abundantcommunityinitiative.commongood.handy.TokenGenerator

class MoveController {

    def authorizationService
    def moveService

    // AJAX. The GSP confirming a deletion can tell us to forget about it.
    def cancel( ) {
        session.moveType = null
        session.moveToken = null
        render ""
    }


    // Prompt user to select block to move address to.
    def selectDestinationBlock( ) {

        Address addressToMove = Address.get( params.long('id') )
        authorizationService.address( addressToMove.id, session )

        log.info "${session.user.getLogName()} select destination block for moving address ${addressToMove.text} (${addressToMove.id})"
        def moveThis = "ADDRESS ${addressToMove.text}"

        def token = TokenGenerator.get( )
        session.moveType = 'address'
        session.moveToken = token

        return [moveThis: moveThis, id: addressToMove.id, magicToken: token ]

    }

    // Determine what people and answers would be lost if a given family were to be
    // deleted (cascading deletions...).
    def selectDestinationAddress( ) {

        Family familyToMove = Family.get( params.long('id') )
        authorizationService.family( familyToMove.id, session )


        log.info "${session.user.getLogName()} select destination address for moving family ${familyToMove.name} (${familyToMove.id})"
        def moveThis = "FAMILY ${familyToMove.name}"

        def token = TokenGenerator.get( )
        session.moveType = 'family'
        session.moveToken = token

        return [moveThis: moveThis, id: familyToMove.id, magicToken: token ]

    }

    // Determine what answers would be lost if a given person were to be
    // deleted (cascading deletion of person's answers).
    def selectDestinationFamily( ) {

        Person personToMove = Person.get( params.long('id') )
        authorizationService.person( personToMove.id, session )

        Neighbourhood neighbourhood = Neighbourhood.get ( personToMove.family.address.block.neighbourhood.id )

        log.info "${session.user.getLogName()} select destination family for moving person ${personToMove.firstNames} ${personToMove.lastName} (${personToMove.id})"
        def moveThis = "${personToMove.firstNames} ${personToMove.lastName}"

        def token = TokenGenerator.get( )
        session.moveType = 'person'
        session.moveToken = token

        return [moveThis: moveThis, nid: neighbourhood.id, id: personToMove.id, magicToken: token ]

    }

    // Move a given address to a different block.
    def address( ) {

        Address addressToMove = Address.get( params.long('id') )
        Block destinationBlock = Block.get( params.long('bid') )

        log.info "${session.user.getLogName()} MOVE address ${addressToMove.text} (${addressToMove.id}) to block ${destinationBlock.code} (${destinationBlock.id})"

        authorizationService.address( addressToMove.id, session )
        authorizationService.block( destinationBlock.id, session )

        if( session.moveType == 'address' && session.moveToken == params.magicToken ) {

            moveService.address( addressToMove, destinationBlock )

            session.moveType = null
            session.moveToken = null

            flash.message = "Moved ADDRESS ${addressToMove.text}"
            flash.nature = 'SUCCESS'
            redirect controller: "navigate", action: "address", id: addressToMove.id

        } else {
            log.error "${session.user.getLogName()} trickery"
            throw new Exception('Illogical move of address')
        }
    }

    // Move a given family to a different address.
    def family( ) {

        Family familyToMove = Family.get( params.long('id') )
        Address destinationAddress = Address.get( params.long('aid') )

        log.info "${session.user.getLogName()} MOVE family ${familyToMove.name} (${familyToMove.id}) to address ${destinationAddress.text} (${destinationAddress.id})"

        authorizationService.family( familyToMove.id, session )
        authorizationService.address( destinationAddress.id, session )

        if( session.moveType == 'family' && session.moveToken == params.magicToken ) {

            moveService.family( familyToMove, destinationAddress )

            session.moveType = null
            session.moveToken = null

            flash.message = "Moved FAMILY ${familyToMove.name}"
            flash.nature = 'SUCCESS'
            redirect controller: "navigate", action: "family", id: familyToMove.id

        } else {
            log.error "${session.user.getLogName()} trickery"
            throw new Exception('Illogical move of family')
        }
    }

    // Move a given person to a different family.
    def person( ) {

        Person personToMove = Person.get( params.long('id') )
        Family destinationFamily = Family.get( params.long('fid') )

        log.info "${session.user.getLogName()} MOVE person ${personToMove.logName} (${personToMove.id}) to family ${destinationFamily.name} (${destinationFamily.id})"

        authorizationService.person( personToMove.id, session )
        authorizationService.family( destinationFamily.id, session )

        if( session.moveType == 'person' && session.moveToken == params.magicToken ) {

            moveService.person( personToMove, destinationFamily )

            session.moveType = null
            session.moveToken = null

            flash.message = "Moved PERSON ${personToMove.firstNames} ${personToMove.lastName}"
            flash.nature = 'SUCCESS'
            redirect controller: "navigate", action: "familymember", id: personToMove.id

        } else {
            log.error "${session.user.getLogName()} trickery"
            throw new Exception('Illogical move of person')
        }
    }
}
