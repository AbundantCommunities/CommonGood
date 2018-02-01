package commongood

import groovy.sql.Sql

/**
 * A monitoring service can make an HTTPS request to this controller in order
 * to prove that Tomcat, this app and our database are working okay.
 */
class WazzupController {

    // Grails injects the default DataSource
    def dataSource

    def index() {
        // The simplest thing we can ask the database for.
        def query = "SELECT 1 FROM this_installation"
        final Sql sql = new Sql(dataSource)

        // The idea is this will blow up if we cannot reach the DB.
        sql.rows( query )
        render 'Happy Neighbouring!'
    }
}
