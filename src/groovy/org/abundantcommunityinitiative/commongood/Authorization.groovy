package org.abundantcommunityinitiative.commongood

/**
 * Specifies what data the application user is authorized to access and whether
 * or not she can change (WRITE) the data.
 */
class Authorization {
    boolean neighbourhood = false // Authorized for a n'hood or a block?
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
