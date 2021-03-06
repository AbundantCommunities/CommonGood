package commongood

import org.abundantcommunityinitiative.commongood.handy.JsonWriter

class AddressController {
    static allowedMethods = [families:'GET', save:'POST']
    def authorizationService
    def addressService
    def gisService
    def reorderService

    def edit( ) {
        def theAddress = Address.get( Long.valueOf( params.id ) )
        [ address: theAddress, boundary:gisService.getBoundaryCoordinates( theAddress.block ) ]
    }

    def reorder( ) {
        def family = Family.get( Long.valueOf( params.familyId ) )
        def address = family.address
        authorizationService.addressWrite( address.id, session )

        def afterId = Long.valueOf( params.afterId )
        if( afterId ) {
            def afterFamily = Family.get( afterId )
            log.info "${session.user.logName} requests move ${family} after ${afterFamily}"
            reorderService.address( family, afterFamily )
        } else {
            log.info "${session.user.logName} requests move ${family} to top"
            reorderService.address( family )
        }

        redirect controller:'navigate', action:'address', id:address.id
    }

    // Get a JSON list of families at a given address
    def families( ) {
        def id = Long.valueOf( params.id )
        authorizationService.addressRead( id, session )
        log.info "${session.user.logName} requests list of families at address/${id}"

        def famAddresses = Family.findAll("from Family fam join fam.address addr where addr.id=? order by fam.orderWithinAddress", [ id ])

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
        log.info "${session.user.logName} update address/${addressId}"
        if( !params.text ) {
            throw new RuntimeException( "address.text is empty [${session.user}]" )
        }
        authorizationService.addressWrite( addressId, session )
        addressService.update( params )

        redirect controller:'navigate', action:'address', id:addressId
    }
}
