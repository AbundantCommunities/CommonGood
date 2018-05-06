package org.abundantcommunityinitiative.commongood.handy

/**
 * This is BAD. It signals an Authentication or Authorization failure deep
 * within the code.
 *
 * In general, a servlet filter or some "high up" code detects authentication
 * and authorization problems and gives the user helpful feedback. We expect to
 * never throw an UnneighbourlyException unless Client Code is Attacking Us.
 * 
 * We chose a vague class name in case the name leaks out to the client.
 */
class UnneighbourlyException extends RuntimeException {

    UnneighbourlyException( ) {
        super( )
        println "WE MAY BE UNDER ATTACK"
    }

    UnneighbourlyException( String msg ) {
        super( msg )
        println "WE MAY BE UNDER ATTACK: ${msg}"
    }
}
