package commongood

class SaveFamilyMemberController {

    def index() {
        println "Params: ${params}"
        render 'SaveFamilyMemberController replaced by PersonController: URL is member/save/123?this=that&etc=moreStuff'
    }
}
