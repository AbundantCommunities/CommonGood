package org.abundantcommunityinitiative.commongood

/**
 * Specifies what data the application user is authorized to access and whether
 * or not she can change the data.
 *
 * "What data" the user may access is specified by two values
 * 1. authorized to access an entire Neighbourhood's data or merely a Block's data.
 * 2. the primary key of the Neighbourhood or Block.
 */
class Authorization {
    boolean neighbourhood = false
    Long domainKey
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
