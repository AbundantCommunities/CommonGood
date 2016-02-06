// We expect our ACI text input file to have no double quotation mark characters.
// Also, we expect cells that had embedded newline characters to be patched up so that
// commas now separate those multiple response strings. Cell contents should be
// separated by tabs.

int TIMESTAMP = 0
int HOUSE_ADDRESS = 1
int BLOCK = 2
int INTERVIEWER = 3
int DATA_PERSON = 4
int NAME = 5
int BIRTH_YEAR = 6
int PHONE = 7
int EMAIL = 8
int LANGUAGES = 9
int VALUES = 10
int IDEALS = 11
int ACTIVITIES = 12
int INTERESTS = 13
int LEAD = 14
int HELP = 15
int SHARE = 16

int OUTSIDE_QUOTE = 0
int INSIDE_QUOTE = 1

def firstLine = true

// Get a field, indexed by columnNo
// Problem is: many lines of text contain fewer than the maximum # of columns
// (don't worry: only trailing, empty columns are missing from the text file)
def getSafely( fields, columnNo ) {
    if( columnNo < fields.size() ) {
        return fields[ columnNo ]
    } else {
        return ''
    }
}

def breakDown( fields, columnNo ) {
    field = getSafely( fields, columnNo )
    return field.tokenize( ',' ).collect {
        // Removed leading & trailing whitespace
        it.trim( )
    }
}

class Person {
    String lastName
    String firstNames
    int birthYear
    String block
    int addressId
    String phone
    String emailAddress
}


class Location {
    int id
    String address
    int blockId
}

nextLocationAndFamilyId = 1
thisFamilyId = 0
addresses = [:]

def getLocationId( String familyAddress, String block, String familyName ) {
    def address = addresses[familyAddress]
    if( address == null ) {
        blockId = getBlockId( block )
        addresses[ familyAddress ] = new Location( id:nextLocationAndFamilyId, address:familyAddress, blockId:blockId )
        println "INSERT INTO address( id, version, block_id, note, text, order_within_block, date_created, last_updated ) \
            VALUES( ${nextLocationAndFamilyId}, 0, ${blockId}, 'note', '${familyAddress}', 100, CURRENT_DATE, CURRENT_DATE );"

        thisFamilyId = nextLocationAndFamilyId
        println "INSERT INTO family( id, version, address_id, name, note, order_within_address, interview_date, interviewer_id, participate_in_interview, permission_to_contact, date_created, last_updated ) \
            VALUES( ${thisFamilyId}, 0, ${nextLocationAndFamilyId}, '${familyName}', 'Note', 100, '2015-07-01', 901, TRUE, TRUE, CURRENT_DATE, CURRENT_DATE );"

        return nextLocationAndFamilyId++
    } else {
        return address.id
    }
}


class Block {
    int id
    String code
    String toString( ) {
        'BLK:' + id + ':' + code
    }
}

nextBlockId = 1
blocks = [:]

def getBlockId( String code ) {
    def block = blocks[code]
    if( block == null ) {
        def orderWithinBlock = Integer.valueOf( code )
        blocks[ code ] = new Block( id:nextBlockId, code:code )
        println "INSERT INTO block( id, version, code, description, neighbourhood_id, order_within_neighbourhood, date_created, last_updated ) \
                        VALUES( ${nextBlockId}, 0, '${code}', 'description', 7, ${orderWithinBlock}, CURRENT_DATE, CURRENT_DATE );"
        return nextBlockId++
    } else {
        return block.id
    }
}

// This singleton record describes the installation of CommonGood on this server:
println "INSERT INTO this_installation( id, version, name, logo, configured ) VALUES( 1, 0, 'Abundant Edmonton Online', NULL, TRUE );"

println "INSERT INTO neighbourhood( id, version, name, date_created, last_updated ) VALUES( 7, 0, 'Bonnie Doon', CURRENT_DATE, CURRENT_DATE );"

println "INSERT INTO person ( id, version, app_user, birth_year, date_created, email_address, family_id, first_names, last_name, last_updated, order_within_family, password_hash, phone_number ) \
VALUES ( 901, 0, FALSE, 0, CURRENT_DATE, 'fabBC@abundantedmonton.ca', NULL, 'Fabian', 'Snufflepuss', CURRENT_DATE, 100, 0, '780-432-6543' );"

println "INSERT INTO question( id, version, code, neighbourhood_id, text, order_within_questionnaire, date_created, last_updated ) \
         VALUES( 1, 0, '1', 7, 'What makes a great neighbourhood?', 100, CURRENT_DATE, CURRENT_DATE );"
println "INSERT INTO question( id, version, code, neighbourhood_id, text, order_within_questionnaire, date_created, last_updated ) \
        VALUES( 2, 0, '2', 7, 'What else can we do to make our neighbourhood a great place to live?', 100, CURRENT_DATE, CURRENT_DATE );"
println "INSERT INTO question( id, version, code, neighbourhood_id, text, order_within_questionnaire, date_created, last_updated ) \
        VALUES( 3, 0, '3', 7, 'What activities would you like to join in with neighbours?', 100, CURRENT_DATE, CURRENT_DATE );"
println "INSERT INTO question( id, version, code, neighbourhood_id, text, order_within_questionnaire, date_created, last_updated ) \
        VALUES( 4, 0, '4', 7, 'Do you have interests that you would value discussing or participating in with neighbours?', 100, CURRENT_DATE, CURRENT_DATE );"
println "INSERT INTO question( id, version, code, neighbourhood_id, text, order_within_questionnaire, date_created, last_updated ) \
        VALUES( 5, 0, '5', 7, 'Do you have a skill, gift or ability that you would be comfortable using to help neighbours or the neighbourhood? ', 100, CURRENT_DATE, CURRENT_DATE );"
println "INSERT INTO question( id, version, code, neighbourhood_id, text, order_within_questionnaire, date_created, last_updated ) \
        VALUES( 6, 0, '6', 7, 'Are there some life experiences that you would consider sharing for the benefit of neighbours?', 100, CURRENT_DATE, CURRENT_DATE );"

nextPersonId = 1
nextAnswerId = 1
previousAddress = ''
familyName = ''

new File('./pureNewLines.txt').eachLine {
    if( firstLine ) {
        /*
        headers = it.tokenize("\t")
        println "Column Headers are:"
        println "    " + headers
        */
        firstLine = false
    } else {
        fields = it.split("\t")
        Person p = new Person( )

        by = getSafely( fields, BIRTH_YEAR )
        p.birthYear = by.size() > 0 ? Integer.parseInt( getSafely( fields, BIRTH_YEAR ) ) : 0

        p.block        = getSafely( fields, BLOCK )
        p.phone        = getSafely( fields, PHONE )
        p.emailAddress = getSafely( fields, EMAIL )

        houseAddress = getSafely( fields, HOUSE_ADDRESS )
        name = getSafely( fields, NAME )
        names = name.tokenize( )

        if( !houseAddress.equals(previousAddress) ) {
            firstPersonInFamily = true
            // This is our best guess for Family Name
            if( names.size() > 1 ) {
                // We assume the last name is the family name
                familyName   = names.last( )
                p.lastName   = familyName
                p.firstNames = names[0..names.size()-2].join(' ')
            } else {
                // A single name. Too bad...
                familyName   = 'SURNAME'
                p.lastName   = familyName
                p.firstNames = name
            }
            previousAddress = houseAddress

        } else {
            firstPersonInFamily = false
            if( names.size() > 1 ) {
                // Family members after the 1st one...
                p.firstNames = names[0..names.size()-2].join(' ')
                if( names.last().equals(familyName) ) {
                    // Discard the last name because it is same as familyName
                    p.lastName = familyName
                } else {
                    p.lastName = names.last( )
                }
            } else {
                p.firstNames = name
                p.lastName   = 'SURNAME'
            }
        }

        // When houseAddress has not previously seen, this method creates INSERT statements
        // for address and family.
        p.addressId = getLocationId( houseAddress, p.block, familyName )

        Integer orderWithinFamily
        if( firstPersonInFamily ) {
            orderWithinFamily = 100
        } else {
            orderWithinFamily = 200
        }

        println "INSERT INTO person( id, version, app_user, birth_year, email_address, family_id, first_names, last_name, password_hash, phone_number, order_within_family, date_created, last_updated ) \
                    VALUES( ${nextPersonId}, 0, FALSE, ${p.birthYear}, '${p.emailAddress}', ${p.addressId}, \$\$${p.firstNames}\$\$, \$\$${p.lastName}\$\$, 0, '${p.phone}', ${orderWithinFamily}, CURRENT_DATE, CURRENT_DATE );"

        texts = breakDown( fields, VALUES )
        texts.each {
            println "INSERT INTO answer( id, version, person_id, question_id, text, would_lead, would_organize, date_created, last_updated ) \
                VALUES( ${nextAnswerId++}, 0, ${nextPersonId}, 1, \$\$${it}\$\$, false, false, CURRENT_DATE, CURRENT_DATE );"
        }

        texts = breakDown( fields, IDEALS )
        texts.each {
            println "INSERT INTO answer( id, version, person_id, question_id, text, would_lead, would_organize, date_created, last_updated ) \
                VALUES( ${nextAnswerId++}, 0, ${nextPersonId}, 2, \$\$${it}\$\$, false, false, CURRENT_DATE, CURRENT_DATE );"
        }

        texts = breakDown( fields, ACTIVITIES )
        texts.each {
            println "INSERT INTO answer( id, version, person_id, question_id, text, would_lead, would_organize, date_created, last_updated ) \
                VALUES( ${nextAnswerId++}, 0, ${nextPersonId}, 3, \$\$${it}\$\$, false, false, CURRENT_DATE, CURRENT_DATE );"
        }

        texts = breakDown( fields, INTERESTS )
        texts.each {
            println "INSERT INTO answer( id, version, person_id, question_id, text, would_lead, would_organize, date_created, last_updated ) \
                VALUES( ${nextAnswerId++}, 0, ${nextPersonId}, 4, \$\$${it}\$\$, false, false, CURRENT_DATE, CURRENT_DATE );"
        }

        texts = breakDown( fields, HELP )
        texts.each {
            println "INSERT INTO answer( id, version, person_id, question_id, text, would_lead, would_organize, date_created, last_updated ) \
                VALUES( ${nextAnswerId++}, 0, ${nextPersonId}, 5, \$\$${it}\$\$, false, false, CURRENT_DATE, CURRENT_DATE );"
        }

        texts = breakDown( fields, SHARE )
        texts.each {
            println "INSERT INTO answer( id, version, person_id, question_id, text, would_lead, would_organize, date_created, last_updated ) \
                VALUES( ${nextAnswerId++}, 0, ${nextPersonId}, 6, \$\$${it}\$\$, false, false, CURRENT_DATE, CURRENT_DATE );"
        }

        nextPersonId++
    }
}

// That's all folks!
