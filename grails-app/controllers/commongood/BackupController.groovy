package commongood

class BackupController {
    def authorizationService
    def backupService

    def index( ) {
        def nh = session.neighbourhood
        authorizationService.neighbourhoodRead( nh.id, session )
        log.info "Extract backup for ${nh}"
        def rows = backupService.extractNeighbourhood( nh.id )
        log.info "Finished ${nh}"
        [
            rows: rows
        ]
    }
}
