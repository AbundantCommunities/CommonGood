package commongood

import grails.test.mixin.TestFor
import grails.test.mixin.TestMixin
import grails.test.mixin.support.GrailsUnitTestMixin
import spock.lang.Specification

/**
 * See the API for {@link grails.test.mixin.support.GrailsUnitTestMixin} for usage instructions
 */
@TestMixin(GrailsUnitTestMixin)
@TestFor(DomainAuthorizationService)
class DomainAuthorizationServiceSpec extends Specification {

    def setup() {
    }

    def cleanup() {
    }

    void "test something"( ) {
        when:
//        def interviewers = service.getPossibleInterviewers( 1, 2, 3 )
        def a = 1
        def b = 2
        
        then:
        3 == a + b
//        interviewers.size( ) == 1
//        interviewers[0].lastName == 'Mickey'
    }
}
