package commongood

class AnswerGroup {

    Neighbourhood neighbourhood
    String name

    static hasMany = [ answers:Answer ]

    static constraints = {
        name maxSize:30, unique:['neighbourhood']
    }
}
