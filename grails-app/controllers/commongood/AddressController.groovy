package commongood

import org.abundantcommunityinitiative.commongood.handy.JsonWriter

class AddressController {
    static allowedMethods = [families:'GET', save:'POST']
    def authorizationService

    def families( ) {
        def id = Long.valueOf( params.id )
        authorizationService.address( id, session )
        log.info "${session.user.getFullName()} requests list of families at address/${id}"

        def famAddresses = Family.findAll("from Family fam join fam.address addr where addr.id=?", [ id ])

        def result = [ ]
        famAddresses.each {
            Family fam = it[0]
            result << [ id:fam.id, name:fam.name ]
        }

        render JsonWriter.write( result )
    }
    
    def save( ) {
        def addressId = params.long('id')
        log.info "${session.user.getFullName()} requests save address/${addressId}"
        authorizationService.address( addressId, session )
        def address = Address.get( addressId )

        if( !params.text ) {
            throw new RuntimeException( "address.text is empty [${session.user}]" )
        }
        address.text = params.text
        address.note = params.note
        address.orderWithinBlock = params.int('orderWithinBlock')
        address.save( flush:true, failOnError: true )

        redirect controller:'navigate', action:'address', id:addressId
    }
}
