package org.abundantcommunityinitiative.commongood

/**
 * Specifies what "level" of information the application user is authorized to use.
 */
class Authorization {
    boolean neighbourhood = false;

    static Authorization getForNeighbourhood( ) {
        return new Authorization( neighbourhood: true )
    }
    
    static Authorization getForBlock( ) {
        return new Authorization( neighbourhood: false )
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
}

