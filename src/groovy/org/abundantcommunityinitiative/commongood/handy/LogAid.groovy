package org.abundantcommunityinitiative.commongood.handy

import commongood.Neighbourhood
import commongood.Person

/**
 * We often want to identify the user and her neighbourhood in something like
 * log.info "LogAid.who(session) just did xyz"
 */
class LogAid {
    static String who( session ) {
        "${session.user.firstNames}${session.user.lastName}/${session.user.id} in ${session.neighbourhood.name}/${session.neighbourhood.id}"
    }
}

