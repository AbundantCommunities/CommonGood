package commongood

class BackupController {
    def backupService

    def index( ) {
        log.info "Extract neighbourhood ${params.id}"
        backupService.extractNeighbourhood( params.long('id') )
        log.info "Finished neighbourhood ${params.id}"
        render "Done"
    }
}
