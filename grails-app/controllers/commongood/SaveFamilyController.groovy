package commongood

class SaveFamilyController {
    def index() {
        println "Params: ${params}"
        render 'SaveFamilyController replaced by FamilyController: URL is family/save/123?this=that&etc=moreStuff'
    }
}
