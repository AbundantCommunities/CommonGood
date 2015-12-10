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
    return field.tokenize( ',' )
}

class Person {
    String lastName
    String firstNames
    int birthYear
    String block
    int locationId
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
locations = [:]

def getLocationId( String address, String block, String familyName ) {
    def location = locations[address]
    if( location == null ) {
        blockId = getBlockId( block )
        locations[ address ] = new Location( id:nextLocationAndFamilyId, address:address, blockId:blockId )
        println 'INSERT INTO location( id, version, block_id, note, official_address, order_within_block ) VALUES( ' + nextLocationAndFamilyId + ', 0, ' + blockId + ', \'\', \'' + address + '\', 10 );'

        // We set the family's primary_member_id to null because we have not yet inserted that person.
        // Later we will update this family row.
        thisFamilyId = nextLocationAndFamilyId
        println 'INSERT INTO family( id, version, family_name, initial_interview_date, interviewer_id, location_id, participate_in_interview, permission_to_contact, primary_member_id ) VALUES( ' +
            thisFamilyId + ', 0, \'' + familyName + '\', \'2015-07-01\', NULL, ' + nextLocationAndFamilyId + ', true, true, NULL );'

        return nextLocationAndFamilyId++
    } else {
        return location.id
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
        blocks[ code ] = new Block( id:nextBlockId, code:code )
        println "INSERT INTO block( id, version, code, neighbourhood_id, order_within_neighbourhood ) VALUES( ${nextBlockId}, 0, '${code}', 1, 10 );"
        return nextBlockId++
    } else {
        return block.id
    }
}

println "INSERT INTO neighbourhood( id, version, name ) VALUES( 1, 0, \'Bonnie Doon\' );"

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
                familyName   = 'familyName?'
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
                p.lastName   = 'familyName?'
            }
        }

        // When houseAddress has not previously seen, this method creates INSERT statements
        // for location and family.
        p.locationId = getLocationId( houseAddress, p.block, familyName )

        println 'INSERT INTO person( id, version, app_user, birth_year, email_address, family_id, first_names, last_name, password_hash, phone_number ) VALUES( ' +
            nextPersonId + ', 0, false, ' + p.birthYear + ', \'' + p.emailAddress + '\', ' + p.locationId + ', \'' + p.firstNames + '\', \'' + p.lastName + '\', 0, \'' + p.phone + '\' );'

        if( firstPersonInFamily ) {
            // Now that we've output the INSERT statement for the first person in the family, we can UPDATE the family
            // row with the person's id (solves a problem with circular references).
            println "UPDATE family SET primary_member_id=${nextPersonId} WHERE id=${p.locationId};"
        }

        texts = breakDown( fields, VALUES )
        texts.each {
            println 'INSERT INTO answer( id, version, person_id, question_code, text, would_lead, would_organize ) VALUES( ' +
                nextAnswerId++ + ', 0, ' + nextPersonId + ', 1, \'' + it + '\', false, true );'
        }

        texts = breakDown( fields, IDEALS )
        texts.each {
            println 'INSERT INTO answer( id, version, person_id, question_code, text, would_lead, would_organize ) VALUES( ' +
                nextAnswerId++ + ', 0, ' + nextPersonId + ', 2, \'' + it + '\', false, true );'
        }

        texts = breakDown( fields, ACTIVITIES )
        texts.each {
            println 'INSERT INTO answer( id, version, person_id, question_code, text, would_lead, would_organize ) VALUES( ' +
                nextAnswerId++ + ', 0, ' + nextPersonId + ', 3, \'' + it + '\', false, true );'

        }

        texts = breakDown( fields, INTERESTS )
        texts.each {
            println 'INSERT INTO answer( id, version, person_id, question_code, text, would_lead, would_organize ) VALUES( ' +
                nextAnswerId++ + ', 0, ' + nextPersonId + ', 4, \'' + it + '\', false, true );'
        }

        texts = breakDown( fields, HELP )
        texts.each {
            println 'INSERT INTO answer( id, version, person_id, question_code, text, would_lead, would_organize ) VALUES( ' +
                nextAnswerId++ + ', 0, ' + nextPersonId + ', 5, \'' + it + '\', false, true );'
        }

        texts = breakDown( fields, SHARE )
        texts.each {
            println 'INSERT INTO answer( id, version, person_id, question_code, text, would_lead, would_organize ) VALUES( ' +
                nextAnswerId++ + ', 0, ' + nextPersonId + ', 6, \'' + it + '\', false, true );'
        }

        nextPersonId++
    }
}

println 'INSERT INTO question( id, version, neighbourhood_id, text ) VALUES( 1, 0, 1, \'What makes a great neighbourhood?\' );'
println 'INSERT INTO question( id, version, neighbourhood_id, text ) VALUES( 2, 0, 1, \'What else can we do to make our neighbourhood a great place to live?\' );'
println 'INSERT INTO question( id, version, neighbourhood_id, text ) VALUES( 3, 0, 1, \'What activities would you like to join in with neighbours?\' );'
println 'INSERT INTO question( id, version, neighbourhood_id, text ) VALUES( 4, 0, 1, \'Do you have interests that you would value discussing or participating in with neighbours?\' );'
println 'INSERT INTO question( id, version, neighbourhood_id, text ) VALUES( 5, 0, 1, \'Do you have a skill, gift or ability that you would be comfortable using to help neighbours or the neighbourhood? \' );'
println 'INSERT INTO question( id, version, neighbourhood_id, text ) VALUES( 6, 0, 1, \'Are there some life experiences that you would consider sharing for the benefit of neighbours?\' );'

// This singleton record describes the installation of CommonGood on this server:
println "INSERT INTO this_installation( id, version, name, logo, configured ) VALUES( 1, 0, 'Abundant Edmonton Online', NULL, TRUE );"

// That's all folks!