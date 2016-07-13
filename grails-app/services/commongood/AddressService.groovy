package commongood

import grails.transaction.Transactional

@Transactional
class AddressService {

    def update( params ) {
        def addressId = params.long('id')
        def address = Address.get( addressId )

        if( address.version != params.int('version') ) {
            throw new Exception('Stale address')
        }

        address.text = params.text
        address.note = params.note
        address.save( flush:true, failOnError: true )
    }
}
