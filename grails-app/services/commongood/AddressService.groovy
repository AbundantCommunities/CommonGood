package commongood

import grails.transaction.Transactional

@Transactional
class AddressService {

    // Update and existing Address
    def update( params ) {
        def addressId = params.long('id')
        def address = Address.get( addressId )

        if( address.version != params.int('version') ) {
            throw new Exception('Stale address')
        }

        address.text = params.text
        address.note = params.note
        if( params.latitude ) {
            address.latitude = new BigDecimal( params.latitude )
        }
        if( params.longitude ) {
            address.longitude = new BigDecimal( params.longitude )
        }

        address.save( flush:true, failOnError: true )
    }
}
