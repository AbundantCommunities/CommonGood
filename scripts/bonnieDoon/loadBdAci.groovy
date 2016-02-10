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
interviewDate = "'2016-02-03 04:05:06'"

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

nextLocationAndFamilyId = 2001
thisFamilyId = 0
addresses = [:]

def getLocationId( String blockConnector, String familyAddress, String block, String familyName ) {
    def address = addresses[familyAddress]
    if( address == null ) {
        blockId = getBlockId( block )
        addresses[ familyAddress ] = new Location( id:nextLocationAndFamilyId, address:familyAddress, blockId:blockId )
        println "INSERT INTO address( id, version, block_id, note, text, order_within_block, date_created, last_updated ) \
            VALUES( ${nextLocationAndFamilyId}, 0, ${blockId}, 'note', '${familyAddress}', 100, ${interviewDate}, ${interviewDate} );"

        thisFamilyId = nextLocationAndFamilyId
        println "INSERT INTO family( id, version, address_id, name, note, order_within_address, interview_date, interviewer_id, participate_in_interview, permission_to_contact, date_created, last_updated ) \
            VALUES( ${thisFamilyId}, 0, ${nextLocationAndFamilyId}, '${familyName}', '${blockConnector}', 100, ${interviewDate}, NULL, TRUE, TRUE, ${interviewDate}, ${interviewDate} );"

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

nextBlockId = 2001
blocks = [:]

def getBlockId( String code ) {
    def block = blocks[code]
    if( block == null ) {
        def orderWithinBlock = Integer.valueOf( code )
        blocks[ code ] = new Block( id:nextBlockId, code:code )
        println "INSERT INTO block( id, version, code, description, neighbourhood_id, order_within_neighbourhood, date_created, last_updated ) \
                        VALUES( ${nextBlockId}, 0, '${code}', 'description', 2000, ${orderWithinBlock}, ${interviewDate}, ${interviewDate} );"
        return nextBlockId++
    } else {
        return block.id
    }
}

// This singleton record describes the installation of CommonGood on this server:
// println "INSERT INTO this_installation( id, version, name, logo, configured ) VALUES( 1, 0, 'Abundant Edmonton Online', NULL, TRUE );"

println 'SET datestyle TO SQL, MDY;'

println "INSERT INTO neighbourhood( id, version, name, date_created, last_updated ) VALUES( 2000, 0, 'Bonnie Doon', ${interviewDate}, ${interviewDate} );"

println "INSERT INTO person ( id, version, app_user, birth_year, date_created, email_address, family_id, first_names, last_name, last_updated, order_within_family, password_hash, phone_number, hashed_password ) \
VALUES ( 2000, 0, TRUE, 1954, ${interviewDate}, 'canuckisman@gmail.com', NULL, 'Mark', 'Gordon', ${interviewDate}, 100, 0, '780-438-6630', \
'PBKDF2WithHmacSHA512|75000|64|256|t0oOpMBpfiDGpFWeE5nQwPyP0iFYYQrjj0lZG56P7ld+MGrnk4VLpIvXS+X/dfjmK26AeHk1K8O2E+aN6kLibg==|QDL10hvD391YJIivIHvOJ275jBVKCME4gx4DRvAkeCY=' );"

println "INSERT INTO domain_authorization( id, version, date_created, domain_code, domain_key, last_updated, person_id, primary_person ) \
VALUES( 2000, 0, '2016-02-06 00:00:00', 'N', 2000, '2016-02-06 00:00:00', 2000, false);"

println "INSERT INTO question( id, version, code, neighbourhood_id, text, order_within_questionnaire, date_created, last_updated, short_text ) \
         VALUES( 2001, 0, '1', 2000, 'What makes a great neighbourhood?', 100, ${interviewDate}, ${interviewDate}, 'Makes a great NH' );"
println "INSERT INTO question( id, version, code, neighbourhood_id, text, order_within_questionnaire, date_created, last_updated, short_text ) \
        VALUES( 2002, 0, '2', 2000, 'Make our neighbourhood a great place to live?', 100, ${interviewDate}, ${interviewDate}, 'Make our NH great' );"
println "INSERT INTO question( id, version, code, neighbourhood_id, text, order_within_questionnaire, date_created, last_updated, short_text ) \
        VALUES( 2003, 0, '3', 2000, 'Activities to join in with neighbours?', 100, ${interviewDate}, ${interviewDate}, 'Activities' );"
println "INSERT INTO question( id, version, code, neighbourhood_id, text, order_within_questionnaire, date_created, last_updated, short_text ) \
        VALUES( 2004, 0, '4', 2000, 'Interests to participate in with neighbours?', 100, ${interviewDate}, ${interviewDate}, 'Interests' );"
println "INSERT INTO question( id, version, code, neighbourhood_id, text, order_within_questionnaire, date_created, last_updated, short_text ) \
        VALUES( 2005, 0, '5', 2000, 'Skill, gift or ability to help neighbours? ', 100, ${interviewDate}, ${interviewDate}, 'Skill, Gift' );"
println "INSERT INTO question( id, version, code, neighbourhood_id, text, order_within_questionnaire, date_created, last_updated, short_text ) \
        VALUES( 2006, 0, '6', 2000, 'Life experiences to share?', 100, ${interviewDate}, ${interviewDate}, 'Life experience' );"

nextPersonId = 2001
nextAnswerId = 2001
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
        interviewDate = "'${getSafely( fields, TIMESTAMP )}'"
        def blockConnector = getSafely( fields, INTERVIEWER )

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
        p.addressId = getLocationId( blockConnector, houseAddress, p.block, familyName )

        Integer orderWithinFamily
        if( firstPersonInFamily ) {
            orderWithinFamily = 100
        } else {
            orderWithinFamily = 200
        }

        println "INSERT INTO person( id, version, app_user, birth_year, email_address, family_id, first_names, last_name, password_hash, phone_number, order_within_family, date_created, last_updated ) \
                    VALUES( ${nextPersonId}, 0, FALSE, ${p.birthYear}, '${p.emailAddress}', ${p.addressId}, \$\$${p.firstNames}\$\$, \$\$${p.lastName}\$\$, 0, '${p.phone}', ${orderWithinFamily}, ${interviewDate}, ${interviewDate} );"

        texts = breakDown( fields, VALUES )
        texts.each {
            println "INSERT INTO answer( id, version, person_id, question_id, text, would_lead, would_organize, date_created, last_updated ) \
                VALUES( ${nextAnswerId++}, 0, ${nextPersonId}, 2001, \$\$${it}\$\$, false, false, ${interviewDate}, ${interviewDate} );"
        }

        texts = breakDown( fields, IDEALS )
        texts.each {
            println "INSERT INTO answer( id, version, person_id, question_id, text, would_lead, would_organize, date_created, last_updated ) \
                VALUES( ${nextAnswerId++}, 0, ${nextPersonId}, 2002, \$\$${it}\$\$, false, false, ${interviewDate}, ${interviewDate} );"
        }

        texts = breakDown( fields, ACTIVITIES )
        texts.each {
            println "INSERT INTO answer( id, version, person_id, question_id, text, would_lead, would_organize, date_created, last_updated ) \
                VALUES( ${nextAnswerId++}, 0, ${nextPersonId}, 2003, \$\$${it}\$\$, false, false, ${interviewDate}, ${interviewDate} );"
        }

        texts = breakDown( fields, INTERESTS )
        texts.each {
            println "INSERT INTO answer( id, version, person_id, question_id, text, would_lead, would_organize, date_created, last_updated ) \
                VALUES( ${nextAnswerId++}, 0, ${nextPersonId}, 2004, \$\$${it}\$\$, false, false, ${interviewDate}, ${interviewDate} );"
        }

        texts = breakDown( fields, HELP )
        texts.each {
            println "INSERT INTO answer( id, version, person_id, question_id, text, would_lead, would_organize, date_created, last_updated ) \
                VALUES( ${nextAnswerId++}, 0, ${nextPersonId}, 2005, \$\$${it}\$\$, false, false, ${interviewDate}, ${interviewDate} );"
        }

        texts = breakDown( fields, SHARE )
        texts.each {
            println "INSERT INTO answer( id, version, person_id, question_id, text, would_lead, would_organize, date_created, last_updated ) \
                VALUES( ${nextAnswerId++}, 0, ${nextPersonId}, 2006, \$\$${it}\$\$, false, false, ${interviewDate}, ${interviewDate} );"
        }

        nextPersonId++
    }
}

// That's all folks!
