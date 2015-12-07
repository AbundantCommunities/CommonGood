// a wee project I played with August, 2015
// idea was to load a CSV file to a SQL table
// assume CSV column names match table names
// later, was to provide a mapping of CSV names to colm names
// believe this does not work (but maybe it does!)

import groovy.json.JsonBuilder
import groovy.util.CliBuilder

class Column {
   String csvName
   String dbName
    String dateType
}

def firstLine = true

new File('data.csv').eachLine {
    if( firstLine ) {
        headers = it.tokenize(",")
        println "Column Headers are:"
        println "    " + headers
        firstLine = false
        def schema = [ ]
        headers.each() {
            schema << new Column( csvName: it, dbName: 'db'+it, dateType: 'S' )
        }
        println new JsonBuilder( schema ).toPrettyString()
    } else {
        println ''
        println it

        int outsideQuote = 0
        int insideQuote = 1
        int state = outsideQuote
        String field = ''
        def values = [ ]

        it.each { ch ->
            if (ch == ',') {
                if (state == insideQuote) {
                    field += ch
                } else {
                    values << field
                    field = ''
                }
            } else {
                if (ch == '"') {
                    if (state == insideQuote) {
                        state = outsideQuote
                    } else {
                        state = insideQuote
                    }
                } else {
                    field += ch
                }
            }
        }
        values << field
        print 'INSERT INTO mytab('
        def first = true
        headers.each{
            if( !first ) {
                print ','
            }
            print it
            first = false
        }
        print ') VALUES ('
        first = true
        values.each{
            if( !first ) {
                print ','
            }
            print it
            first = false
        }
        println ')'
    }
}
