package commongood

class BlockController {
    static allowedMethods = [addAddresses:'POST', addConnector:'POST', contactList:'GET', save:'POST']

    def domainAuthorizationService
    def authorizationService

    /**
     * You can POST a single blob of text containing N new addresses
     * for this block. Separate addresses with newline characters.
     */
    def addAddresses( ) {
        def blockId = Long.parseLong( params.id )
        authorizationService.block( blockId, session )
        def thisBlock = Block.get( blockId )

        // Let's find the largest value of order_within_block and go from there...
        def query = Address.where {
            block.id == blockId
        }.projections {
            max('orderWithinBlock')
        }
        def lastOrder = query.find() as Integer

        def addresses = params.addresses.tokenize( '\n' )
        addresses.each {
            println "Adding address: ${it} to ${thisBlock}"
            Address addr = new Address( )
            addr.block = thisBlock
            addr.text = it
            addr.note = ''
            lastOrder += 100
            addr.orderWithinBlock = lastOrder
            addr.save( flush:true, failOnError: true )
        }

        forward controller:'navigate', action:'block', id:blockId
    }

    /**
    * Given an address id plus basic info about a person, make a Person plus a family
    * for that person. Make the new person a member of the family. Make the new family
    * a family of the address. Finally, make a new DomainAuthorization so that the new
    * person is a Block Connector for the block the address is within.
    */
    def addConnector( ) {
        // FIXME make all the database work in this controller occur in a single transaction
        def addressId = Long.valueOf( params.addressId )
        Address address = Address.get( addressId )
        def blockId = address.block.id
        
        Family family = new Family( )
        family.address = address
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

    def contactList() {
        def blockId = Long.parseLong( params.id )
        def block = Block.get( blockId )
        def connectors = domainAuthorizationService.getBlockConnectors( blockId )

        def blockPeople = Person.findAll(
        'from Person p join p.family f join f.address a where a.block.id=? order by f.name, f.id, p.orderWithinFamily, p.id',
        [blockId] )

        def lastFamily = new Family( id:-1 )
        def families = [ ]
        def result = [ block:block, connectors:connectors, families:families ]
        def currentMembers = [ ]

        blockPeople.each{
            Person p = it[0]
            Family f = it[1]
            Address a = it[2]
            if( f.id != lastFamily.id ) {
                currentMembers = [ ]
                families << [ thisFamily:f, members:currentMembers ]
                lastFamily = f
            }
            currentMembers << p
        }

        result
    }

    def save( ) {
        def blockId = Long.parseLong( params.id )
        authorizationService.block( blockId, session )
        def neighbourhood = Block.get( blockId )

        block.code = params.code
        block.description = params.description
        block.orderWithinNeighbourhood = params.orderWithinNeighbourhood

        block.save( flush:true, failOnError: true )
        forward controller: "navigate", action: "block", id: blockId
    }
}
