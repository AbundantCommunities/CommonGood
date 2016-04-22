package commongood

import org.abundantcommunityinitiative.commongood.handy.JsonWriter

class AddressController {
    static allowedMethods = [families:'GET', save:'POST']
    def authorizationService
    def addressService

    // Get a JSON list of families at a given address
    def families( ) {
        def id = Long.valueOf( params.id )
        authorizationService.address( id, session )
        log.info "${session.user.getLogName()} requests list of families at address/${id}"

        def famAddresses = Family.findAll("from Family fam join fam.address addr where addr.id=?", [ id ])

        def result = [ ]
        famAddresses.each {
            Family fam = it[0]
            result << [ id:fam.id, name:fam.name ]
        }

        render JsonWriter.write( result )
    }

    // Update an existing Address.
    def save( ) {
        def addressId = params.long('id')
        log.info "${session.user.getLogName()} update address/${addressId}"
        if( !params.text ) {
            throw new RuntimeException( "address.text is empty [${session.user}]" )
        }
        authorizationService.address( addressId, session )
        addressService.update( params )

        redirect controller:'navigate', action:'address', id:addressId
    }
}
