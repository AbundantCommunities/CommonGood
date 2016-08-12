package commongood

import grails.test.mixin.TestFor
import spock.lang.Specification

/**
 * See the API for {@link grails.test.mixin.services.ServiceUnitTestMixin} for usage instructions
 */
@TestFor(PermuteService)
class PermuteServiceSpec extends Specification {

    def permuteService = new PermuteService( )

    void "text begins with a common word"() {
        given: 'input begins with one of our declared common words'
        def text = 'the best place'
        
        when: 'we permute the string'
        def perm = permuteService.permute( text )
        
        then: 'the original text is not one of the permutations'
        assert perm.size() == 2
        assert 'best place, the' in perm
        assert 'place, the best' in perm
    }

    void "one word"() {
        given: 'input is a single word'
        def text = 'apple'
        
        when: 'we permute the string'
        def perm = permuteService.permute( text )
        
        then: 'we get the one word back'
        assert perm == ['apple']
    }

    void "lots of common words"() {
        given: 'does not permute on common words'
        def text = 'by fewer apple is in Bermuda'
        
        when: 'we permute the string'
        def perm = permuteService.permute( text )
        
        then: 'we get a small number of permutations back'
        assert perm.size() == 2
        assert 'apple is in bermuda, by fewer' in perm
        assert 'bermuda, by fewer apple is in' in perm
    }

    void "empty string"() {
        given: 'an empty input string'
        def text = ''

        when: 'we permute the string'
        def perm = permuteService.permute( text )
        
        then: 'ther result is an empty list'
        assert perm.size() == 0
    }
}
