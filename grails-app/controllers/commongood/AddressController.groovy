package commongood

class AddressController {
    static allowedMethods = [families:'GET', save:'POST']
    def authorizationService

    def families( ) {
        def id = Long.valueOf( params.id )
        authorizationService.address( id, session )

        def famAddresses = Family.findAll("from Family fam join fam.address addr where addr.id=?", [ id ])

        def result = [ ]
        famAddresses.each {
            Family fam = it[0]
            result << [ id:fam.id, name:fam.name ]
        }

        def bldr = new groovy.json.JsonBuilder( result )
        def writer = new StringWriter()
        bldr.writeTo(writer)
        render writer
    }
    
    def save( ) {
        def addressId = Long.parseLong( params.id )
        authorizationService.address( addressId, session )
        def address = Address.get( addressId )

        address.text = params.text
        address.note = params.note
        address.orderWithinBlock = Integer.parseInt( params.orderWithinBlock )
        address.save( flush:true, failOnError: true )

        forward controller:'navigate', action:'address', id:addressId
    }
}
