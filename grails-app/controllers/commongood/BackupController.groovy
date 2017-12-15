package commongood

class BackupController {
    def backupService

    def index( ) {
        backupService.extractNeighbourhood( params.long('id') )
        render "Done"
    }
}
