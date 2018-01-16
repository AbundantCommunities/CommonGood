package commongood

import org.codehaus.groovy.grails.core.io.ResourceLocator
import org.springframework.core.io.Resource

class BackupController {
    def authorizationService
    def backupService

    def index( ) {
        def nh = session.neighbourhood
        authorizationService.neighbourhoodRead( nh.id, session )
        log.info "Extract backup for ${nh}"

        def rows = backupService.extractNeighbourhood( nh.id )

        response.setContentType("text/csv")
        response.setHeader("Content-disposition", "filename=aciGuardThisData.txt")
        rows.each {
            response.outputStream << it.getBytes() << "\n"
        }

        response.outputStream.flush()
        log.info "Finished ${nh}"
    }
}