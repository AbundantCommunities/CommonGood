package commongood

import org.abundantcommunityinitiative.commongood.handy.JsonWriter

class BlockController {
    static allowedMethods = [addAddresses:'POST', addConnector:'POST', contactList:'GET', save:'POST']

    def domainAuthorizationService
    def authorizationService
    def reorderService

    def reorder( ) {
        def address = Address.get( Long.valueOf( params.addressId ) )
        def block = address.block
        authorizationService.block( block.id, session )

        def afterId = Long.valueOf( params.afterId )
        if( afterId ) {
            def afterAddress = Address.get( afterId )
            log.info "${session.user.getLogName()} requests move ${address} after ${afterAddress}"
            reorderService.block( address, afterAddress )
        } else {
            log.info "${session.user.getLogName()} requests move ${address} to top"
            reorderService.block( address )
        }

        redirect controller:'navigate', action:'block', id:block.id
    }

    /**
     * You can POST a single blob of text containing N new addresses
     * for this block. Separate addresses with newline characters.
     */
    def addAddresses( ) {
        def blockId = Long.parseLong( params.id )
        log.info "${session.user.getLogName()} requests add address(es) block/${blockId}"
        authorizationService.block( blockId, session )
        def thisBlock = Block.get( blockId )

        // Let's find the largest value of order_within_block and go from there...
        def query = Address.where {
            block.id == blockId
        }.projections {
            max('orderWithinBlock')
        }
        def lastOrder = query.find() as Integer
        lastOrder = lastOrder ?: 0

        def addresses = params.addresses.tokenize( '\n' )
        addresses.each {
            // Use Java regular expression to remove "control" characters
            // (We are getting a \r char at end of each address except last 2016.1)
            def cleanAddress = it.replaceAll('\\p{Cntrl}', '').trim( )
            if( cleanAddress ) {
                log.debug "Adding address: ${cleanAddress} to ${thisBlock}"
                Address addr = new Address( )
                addr.block = thisBlock
                addr.text = cleanAddress
                addr.note = ''
                lastOrder += 100
                addr.orderWithinBlock = lastOrder
                addr.save( flush:true, failOnError: true )
            }
        }

        redirect controller:'navigate', action:'block', id:blockId
    }

    def contactList() {
        def blockId = Long.parseLong( params.id )
        authorizationService.block( blockId, session )

        def block = Block.get( blockId )
        log.info "${session.user.getLogName()} requests Contact List for block/${blockId}"
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
        def blockId = params.long('id')
        log.info "${session.user.getLogName()} requests save change to block/${blockId}"
        authorizationService.block( blockId, session )
        def block = Block.get( blockId )

        block.code = params.code.trim( )
        block.description = params.description.trim( )

        if( block.code ) {
            block.save( flush:true, failOnError: true )
            redirect controller: "navigate", action: "block", id: blockId
        } else {
            throw new RuntimeException( "Empty code and/or description?" )
        }
    }

    def addBlockConnector ( ) {
        def blockId = params.long('id')
        def personId = params.long('pid')
        //def block = Block.get( blockId )
        def person = Person.get( personId )

        log.info "${session.user.getLogName()} requests add BC person/${personId} to block/${blockId}"

        authorizationService.block( blockId, session )

        // Find the largest value of orderWithinDomain and go from there...
        def query = DomainAuthorization.where {
            domainCode == 'B' && domainKey == blockId
        }.projections {
            max('orderWithinDomain')
        }
        def lastOrder = query.find() as Integer
        
        lastOrder = lastOrder ?: 0

        // The person becomes a BC for his block
        DomainAuthorization da = new DomainAuthorization( )
        da.person = person
        da.domainCode = DomainAuthorization.BLOCK
        da.domainKey = blockId as Integer
        da.orderWithinDomain = lastOrder + 100
        da.save( flush:true, failOnError: true )
        redirect controller:'navigate', action:'block', id:blockId


    }

    // Get a JSON list of addresses for a given block
    def addresses( ) {
        def id = Long.valueOf( params.id )
        authorizationService.block( id, session )
        log.info "${session.user.getLogName()} requests list of addresses for block/${id}"

        def blockAddresses = Address.findAll("from Address addr join addr.block blk where blk.id=?", [ id ])

        def result = [ ]
        blockAddresses.each {
            Address addr = it[0]
            result << [ id:addr.id, text:addr.text ]
        }

        render JsonWriter.write( result )
    }


}
