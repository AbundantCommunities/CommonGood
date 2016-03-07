package commongood

import grails.test.mixin.TestFor
import spock.lang.Specification

/**
 * See the API for {@link grails.test.mixin.web.ControllerUnitTestMixin} for usage instructions
 */
@TestFor(AddressController)
class AddressControllerSpec extends Specification {

    def setup() {
    }

    def cleanup() {
    }

    void "test something"( ) {
        given: "Some stuff we create now"
        def thing = 'whatzit'
        
        when: "We act on that stuff"
        def tLen = thing.size( )
        
        then: "The size method counted characters in our stuff"
        tLen == 7
    }
}
