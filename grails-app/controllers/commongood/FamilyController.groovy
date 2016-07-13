package commongood

import org.abundantcommunityinitiative.commongood.handy.JsonWriter

class FamilyController {
    static allowedMethods = [members:'GET', save:'POST']
    def authorizationService
    def reorderService

    def reorder( ) {
        def person = Person.get( Long.valueOf( params.personId ) )
        def family = person.family
        authorizationService.family( family.id, session )

        def afterId = Long.valueOf( params.afterId )
        if( afterId ) {
            def afterPerson = Person.get( afterId )
            log.info "${session.user.getLogName()} requests move ${person} after ${afterPerson}"
            reorderService.family( person, afterPerson )
        } else {
            log.info "${session.user.getLogName()} requests move ${person} to top"
            reorderService.family( person )
        }

        redirect controller:'navigate', action:'family', id:family.id
    }

    // Returns members of a given family
    // JSON call -- used by Add Block Connector
    def members( ) {
        def id = Long.valueOf( params.id )
        authorizationService.family( id, session )
        def famAddresses = Person.findAll("from Person p join p.family as f where f.id=?", [ id ])

        def result = [ ]
        famAddresses.each {
            Person member = it[0]
            result << [ id:member.id, name:member.fullName ]
        }

        render JsonWriter.write( result )
    }

    def save() {
        Family family
        def newFamily
        if( 'id' in params ) {
            // The request wants us to change an existing family.
            // We will not change the family's address.
            def familyId = Long.valueOf( params.id )
            authorizationService.family( familyId, session )
            log.info "${session.user.getLogName()} requests save changes for family/${familyId}"
            family = Family.get( familyId )
            newFamily = false
        } else {
            // The request is to create a new family.
            // We need to get the family's address from the request.
            family = new Family( )
            def addressId = Long.valueOf( params.addressId )
            authorizationService.address( addressId, session )
            log.info "${session.user.getLogName()} requests add a family to address/${addressId}"
            family.address = Address.get( addressId )
            family.participateInInterview = Boolean.FALSE
            family.permissionToContact = Boolean.FALSE
            newFamily = true
        }
        family.name = params.familyName
        family.note = params.note
        if( params.orderWithinAddress ) {
            family.orderWithinAddress = params.int('orderWithinAddress')
        } else {
            // Find the largest value of orderWithinAddress and go from there...
            def query = Family.where {
                address.id == family.address.id
            }.projections {
                max('orderWithinAddress')
            }
            def lastOrder = query.find() as Integer
            lastOrder = lastOrder ?: 0
            family.orderWithinAddress = lastOrder + 100
        }

        // TODO Replace failOnError with logic
        family.save( flush:true, failOnError: true )
        if( newFamily ) {
            redirect controller:'navigate', action:'address', id:family.address.id
        } else {
            redirect controller:'navigate', action:'family', id:family.id
        }
    }
}
