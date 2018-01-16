package commongood

import grails.transaction.Transactional
import java.lang.StringBuffer

/**
 * We create a great honkin' list of text strings containing all the data recorded for
 * a given neighbourhood.
 */
@Transactional
class BackupService {

    def extractNeighbourhood( Long neighbourhoodId ) {
        def result = [ ]

        Neighbourhood nh = Neighbourhood.get( neighbourhoodId )
        Question[] questions = Question.findAllByNeighbourhood( nh, [sort: 'orderWithinQuestionnaire'] )
        questions.each {
            result <<= "question,${it.id},${wrap(it.code)},${wrap(it.shortText)},${wrap(it.text)}"
        }

        Block[] blocks = Block.findAllByNeighbourhood( nh, [sort: 'orderWithinNeighbourhood'] )
        blocks.each {
            result <<= "block,${it.id},${wrap(it.code)},${wrap(it.description)}"
        }

        def addressesAll = [ ]

        blocks.each {
            Address[] addresses = Address.findAllByBlock( it, [sort: 'orderWithinBlock'] )
            addresses.each {
                result <<= "address,${it.id},${it.block.id},${wrap(it.text)},${wrap(it.note)}"
                addressesAll << it
            }
        }

        // At this point we can dispense with the blocks, to save heap space
        blocks = null
        def familiesAll = [ ]

        addressesAll.each {
            Family[] families = Family.findAllByAddress( it, [sort: 'orderWithinAddress'] )
            families.each {
                result <<= "family,${it.id},${it.address.id},${wrap(it.name)},${wrap(it.note)}"
                familiesAll << it
            }
        }

        // At this point we can dispense with the addresses, to save heap space
        addressesAll = null
        def personsAll = [ ]

        familiesAll.each {
            Person[] persons = Person.findAllByFamily( it, [sort: 'orderWithinFamily'] )
            persons.each {
                result <<= "person,${it.id},${it.family.id},${wrap(it.firstNames)},${wrap(it.lastName)},${wrap(it.emailAddress)},${wrap(it.phoneNumber)},${it.birthYear},${wrap(it.note)}"
                personsAll << it
            }
        }

        // At this point we can dispense with the families, to save heap space
        familiesAll = null
        personsAll.each {
            Answer[] answers = Answer.findAllByPerson( it, [sort: 'question'] )
            answers.each {
                result <<= "answer,${it.id},${it.person.id},${it.question.id},${wrap(it.text)},${wrap(it.note)},${it.wouldAssist}"
            }
        }

        return result
    }

    def wrap( String text ) {
        // Replace apostrophe character (') with two apostrophes ('').
        // That is the SQL standard for embedding apostrophe within a string literal.
        // Replace ASCII Carriage Return + Line Feed with \n.
        // Finally, enclose the entire string in apostrophes.
        def escaped = text.replace( "'", "''" ).replace( "\r\n", '\\n' )
        return "'${escaped}'"
    }
}
