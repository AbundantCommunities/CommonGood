package commongood

/**
 * Test production to see if stacktrace is visible (should NOT be!).
 */
class KaboomController {

    def index() {
        log.info 'ka-BOOM !!'
        throw new RuntimeException('You asked for it!')
    }
}
