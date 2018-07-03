package org.abundantcommunityinitiative.commongood.handy

class JsonWriter {

    // TODO Remove this class and instead use groovy.json.JsonOutput

    static String write( thing ) {
        def bldr = new groovy.json.JsonBuilder( thing )
        def writer = new StringWriter( )
        bldr.writeTo( writer )
        return writer.toString( )
    }
}

