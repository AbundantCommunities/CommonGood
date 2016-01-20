package commongood

class BlockController {
    static allowedMethods = [contactList:'GET']

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
}
