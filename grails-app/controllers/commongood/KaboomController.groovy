package commongood

class KaboomController {

    def index() {
        throw new RuntimeException('You asked for it!')
    }
}
