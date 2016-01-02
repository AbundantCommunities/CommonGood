package commongood

class HomePageTestController {

    def youAreHome( ) {
        println 'in HomePageTestController with ${session}'
        session.myval = "hi ho, buddy!"
    }
}
