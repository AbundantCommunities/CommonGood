package org.abundantcommunityinitiative.commongood

/**
 * Specifies what "level" of information the application user is authorized to use
 * and the primary key of the relevant Neighbourhood or Block.
 */
class Authorization {
    boolean neighbourhood = false
    Long domainKey

    static Authorization getForNeighbourhood( id  ) {
        return new Authorization( neighbourhood: true, domainKey: id )
    }
    
    static Authorization getForBlock( id ) {
        return new Authorization( neighbourhood: false, domainKey: id )
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

    String toString( ) {
        "[Authorization ${neighbourhood?'NH':'BLK'} ${domainKey}]"
    }
}

