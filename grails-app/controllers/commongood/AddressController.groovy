package commongood

class AddressController {
    static allowedMethods = [addBlockController:'GET', families:'GET']

    /**
    * Given an address id plus basic info about a person, make a Person plus a family
    * for that person. Make the new person a member of the family. Make the new family
    * a family of the address. Finally, make a new DomainAuthorization so that the new
    * person is a Block Connector for the block the address is within.
    */
    def addBlockController( ) {
        // FIXME make all the database work in this controller occur in a single transaction
        def addressId = Long.valueOf( params.id )
        Address thisAddress = Address.get( addressId )
        def blockId = thisAddress.block.id
        
        Family family = new Family( )
        family.address = thisAddress
        family.name = params.lastName
        family.participateInInterview = true
        family.permissionToContact = true
        family.note = ''
        family.interviewDate = null
        family.orderWithinAddress = 100
        family.save( flush:true, failOnError: true )

        Person person = new Person( )
        person.family = family
        person.firstNames = params.firstNames
        person.lastName = params.lastName
        person.birthYear = Integer.valueOf( params.birthYear )
        person.emailAddress = params.emailAddress
        person.phoneNumber = params.phoneNumber
        person.orderWithinFamily = 100
        person.save( flush:true, failOnError: true )

        DomainAuthorization dauth = new DomainAuthorization( )
        dauth.domainCode = DomainAuthorization.BLOCK
        dauth.person = person
        dauth.primaryPerson = Boolean.TRUE
        dauth.domainKey = blockId
        dauth.save( flush:true, failOnError: true )

        forward controller:'navigate', action:'block', id:blockId
    }

    def families( ) {
        def id = Long.valueOf( params.id )
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
}
