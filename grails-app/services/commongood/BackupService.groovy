package commongood

import grails.transaction.Transactional

@Transactional
class BackupService {

    def extractNeighbourhood( Long neighbourhoodId ) {
        Neighbourhood nh = Neighbourhood.get( neighbourhoodId )
        Question[] questions = Question.findAllByNeighbourhood( nh, [sort: 'orderWithinQuestionnaire'] )
        questions.each {
            println "question,${it.id},${it.code},${it.text}"
        }

        Block[] blocks = Block.findAllByNeighbourhood( nh, [sort: 'orderWithinNeighbourhood'] )
        blocks.each {
            println "block,${it.id},${it.code},${it.description}"
        }

        def addressesAll = [ ]

        blocks.each {
            Address[] addresses = Address.findAllByBlock( it, [sort: 'orderWithinBlock'] )
            addresses.each {
                println "address,${it.block.id},${it.id},${it.text},${it.note}"
                addressesAll << it
            }
        }

        // At this point we can dispense with the blocks, to save heap space
        blocks = null
        def familiesAll = [ ]

        addressesAll.each {
            Family[] families = Family.findAllByAddress( it, [sort: 'orderWithinAddress'] )
            families.each {
                println "family,${it.address.id},${it.id},${it.name},${it.note}"
                familiesAll << it
            }
        }

        // At this point we can dispense with the addresses, to save heap space
        addressesAll = null
        def personsAll = [ ]

        familiesAll.each {
            Person[] persons = Person.findAllByFamily( it, [sort: 'orderWithinFamily'] )
            persons.each {
                println "person,${it.family.id},${it.id},${it.firstNames},${it.lastName},${it.emailAddress}"
                personsAll << it
            }
        }

        // At this point we can dispense with the families, to save heap space
        familiesAll = null
        personsAll.each {
            Answer[] answers = Answer.findAllByPerson( it, [sort: 'question'] )
            answers.each {
                println "answer,${it.person.id},${it.question.id},${it.id},${it.text},${it.note}"
            }
        }
    }
}
