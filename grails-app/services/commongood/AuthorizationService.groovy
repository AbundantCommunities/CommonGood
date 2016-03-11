package commongood

import grails.transaction.Transactional

@Transactional
class AuthorizationService {

    // We rely on our our Grails Filters to ensure that requests come from
    // authenticated users. However, if the filters fail to do that, then
    // the "checking methods" below will "blow up".

    def prevent( layer, id, session ) {
        log.warn "Authorization failure: attempt to access ${layer}:${id} by ${session.user}"
        throw new Exception( 'Not allowed' )
    }

    // Quietly exits if user is authorized to change neighbourhood whose PK is id,
    // else throws an exception
    def neighbourhood( id, session ) {
        if( id != session.neighbourhood.id ) {
            prevent( 'Neighbourhood', id, session )
        }
    }

    // Quietly exits if user is authorized to change block whose PK is id,
    // else throws an exception
    def block( id, session ) {
        if( Block.get(id).neighbourhood.id != session.neighbourhood.id ) {
            prevent( 'Block', id, session )
        }
    }

    // Quietly exits if user is authorized to change address whose PK is id,
    // else throws an exception
    def address( id, session ) {
        if( Address.get(id).block.neighbourhood.id != session.neighbourhood.id ) {
            prevent( 'Address', id, session )
        }
    }

    // Quietly exits if user is authorized to change family whose PK is id,
    // else throws an exception
    def family( id, session ) {
        if( Family.get(id).address.block.neighbourhood.id != session.neighbourhood.id ) {
            prevent( 'Family', id, session )
        }
    }

    // Quietly exits if user is authorized to change the person whose PK is id,
    // else throws an exception
    def person( id, session ) {
        if( Person.get(id).family.address.block.neighbourhood.id != session.neighbourhood.id ) {
            prevent( 'Person', id, session )
        }
    }

    // Quietly exits if user is authorized to change the answer whose PK is id,
    // else throws an exception.
    def answer( id, session ) {
        if( Answer.get(id).person.family.address.block.neighbourhood.id != session.neighbourhood.id ) {
            prevent( 'Answer', id, session )
        }
    }
}
