package org.abundantcommunityinitiative.commongood.handy

class JsonWriter {

    static String write( thing ) {
        def bldr = new groovy.json.JsonBuilder( thing )
        def writer = new StringWriter( )
        bldr.writeTo( writer )
        return writer.toString( )
    }
}

