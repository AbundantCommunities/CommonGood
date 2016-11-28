package commongood

import grails.transaction.Transactional

@Transactional
class AuthorizationService {

    // We rely on our our Grails Filters to ensure that requests come from
    // authenticated users. However, if the filters fail to do that, then
    // the "checking methods" below should "blow up" when they try to access
    // session.neighbourhood or session.block; that would be a good thing.

    // This shouldn't happen. Immediately stop user from accessing a specific
    // layer of the data hierarchy.
    def preventLayer( layer, id, session ) {
        log.warn "Authorization failure: prevent access of ${layer}:${id} by ${session.user.logName}"
        throw new Exception( 'Authorization failure' )
    }

    // This shouldn't happen. Immediately stop user from accessing a specific
    // layer of the data hierarchy.
    def preventWrite( layer, id, session ) {
        log.warn "Authorization failure: prevent change of ${layer}:${id} by ${session.user.logName}"
        throw new Exception( 'Authorization failure' )
    }

    // Quietly exits if user is authorized to change neighbourhood whose PK is id,
    // else throws an exception
    def neighbourhoodWrite( id, session ) {
        if( session.authorized.canWrite() ) {
            neighbourhoodRead( id, session )
        } else {
            preventWrite( 'Neighbourhood', id, session )
        }
    }

    // Quietly exits if user is authorized to read neighbourhood whose PK is id,
    // else throws an exception
    def neighbourhoodRead( id, session ) {
        if( session.authorized.forNeighbourhood() ) {
            if( id != session.neighbourhood.id ) {
                preventLayer( 'Neighbourhood', id, session )
            }
        } else {
            if( id != session.block.neighbourhood.id ) {
                preventLayer( 'Neighbourhood', id, session )
            }
        }
    }

    // Quietly exits if user is authorized to change block whose PK is id,
    // else throws an exception
    def blockWrite( id, session ) {
        if( session.authorized.canWrite() ) {
            blockRead( id, session )
        } else {
            preventWrite( 'Block', id, session )
        }
    }

    // Quietly exits if user is authorized to read block whose PK is id,
    // else throws an exception
    def blockRead( id, session ) {
        if( session.authorized.forNeighbourhood() ) {
            if( Block.get(id).neighbourhood.id != session.neighbourhood.id ) {
                preventLayer( 'Block', id, session )
            }
        } else {
            if( id != session.block.id ) {
                preventLayer( 'Block', id, session )
            }
        }
    }

    // Quietly exits if user is authorized to change address whose PK is id,
    // else throws an exception
    def addressWrite( id, session ) {
        if( session.authorized.canWrite() ) {
            addressRead( id, session )
        } else {
            preventWrite( 'Address', id, session )
        }
    }

    // Quietly exits if user is authorized to read address whose PK is id,
    // else throws an exception
    def addressRead( id, session ) {
        if( session.authorized.forNeighbourhood() ) {
            if( Address.get(id).block.neighbourhood.id != session.neighbourhood.id ) {
                preventLayer( 'Address', id, session )
            }
        } else {
            if( Address.get(id).block.id != session.block.id ) {
                preventLayer( 'Address', id, session )
            }
        }
    }

    // Quietly exits if user is authorized to change family whose PK is id,
    // else throws an exception
    def familyWrite( id, session ) {
        if( session.authorized.canWrite() ) {
            familyRead( id, session )
        } else {
            preventWrite( 'Family', id, session )
        }
    }

    // Quietly exits if user is authorized to read family whose PK is id,
    // else throws an exception
    def familyRead( id, session ) {
        if( session.authorized.forNeighbourhood() ) {
            if( Family.get(id).address.block.neighbourhood.id != session.neighbourhood.id ) {
                preventLayer( 'Family', id, session )
            }
        } else {
            if( Family.get(id).address.block.id != session.block.id ) {
                preventLayer( 'Family', id, session )
            }
        }
    }

    // Quietly exits if user is authorized to change the person whose PK is id,
    // else throws an exception
    def personWrite( id, session ) {
        if( session.authorized.canWrite() ) {
            personRead( id, session )
        } else {
            preventWrite( 'Person', id, session )
        }
    }

    // Quietly exits if user is authorized to read the person whose PK is id,
    // else throws an exception
    def personRead( id, session ) {
        if( session.authorized.forNeighbourhood() ) {
            if( Person.get(id).family.address.block.neighbourhood.id != session.neighbourhood.id ) {
                preventLayer( 'Person', id, session )
            }
        } else {
            if( Person.get(id).family.address.block.id != session.block.id ) {
                preventLayer( 'Person', id, session )
            }
        }
    }

    // Quietly exits if user is authorized to change the answer whose PK is id,
    // else throws an exception.
    def answerWrite( id, session ) {
        if( session.authorized.canWrite() ) {
            answerRead( id, session )
        } else {
            preventWrite( 'Answer', id, session )
        }
    }

    // Quietly exits if user is authorized to read the answer whose PK is id,
    // else throws an exception.
    def answerRead( id, session ) {
        if( session.authorized.forNeighbourhood() ) {
            if( Answer.get(id).person.family.address.block.neighbourhood.id != session.neighbourhood.id ) {
                preventLayer( 'Answer', id, session )
            }
        } else {
            if( Answer.get(id).person.family.address.block.id != session.block.id ) {
                preventLayer( 'Answer', id, session )
            }
        }
    }
}
