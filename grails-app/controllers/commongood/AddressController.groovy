package commongood

class AddressController {

    def families( ) {
        def id = Long.valueOf( params.id )
        def famAddresses = Family.findAll("from Family fam join fam.address as addr where addr.id=?", [ id ])

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
}
