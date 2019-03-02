package org.abundantcommunityinitiative.commongood

/**
 * Specifies what data the user is authorized to access. Just a plain ol' bean,
 * really.
 *
 * A user can be authorized to access a given Neighbourhood or a given Block
 * (a Neighbourhood owns many Blocks). Addditionally, the user's authorization
 * allows both read access and write access OR just read access.
 */
class Authorization {
    boolean neighbourhood = false // Authorized for a neighbourhoodhood? (else block)
    Long domainKey  // The id of the neighbourhood or the block
    boolean write

    static Authorization getForNeighbourhood( id, write ) {
        return new Authorization( neighbourhood: true, domainKey: id, write:write )
    }

    static Authorization getForBlock( id, write ) {
        return new Authorization( neighbourhood: false, domainKey: id, write:write )
    }

    Boolean forNeighbourhood( ) {
        if( neighbourhood ) {
            Boolean.TRUE
        } else {
            Boolean.FALSE
        }
    }

    Boolean forBlock( ) {
        if( neighbourhood ) {
            Boolean.FALSE
        } else {
            Boolean.TRUE
        }
    }

    Boolean canWrite( ) {
        if( write ) {
            Boolean.TRUE
        } else {
            Boolean.FALSE
        }
    }

    String toString( ) {
        "[Authorization ${neighbourhood?'NH':'BLK'} ${domainKey} ${write?'WRITE':'READONLY'}]"
    }
}
