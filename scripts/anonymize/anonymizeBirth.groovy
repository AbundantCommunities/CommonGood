Long lowId = Long.parseLong( args[0] )
Long highId = Long.parseLong( args[1] )

for( id in lowId..highId ) {
    base = new Random().nextInt(4)
    switch( base ) {
        case 0:
            rAdjust = -1
            break;
        case 1:
            rAdjust = 1
            break;
        case 2:
            rAdjust = 2
            break;
        default:
            rAdjust = 3
    }
    println "UPDATE person SET birth_year = birth_year + ${rAdjust} WHERE id=${id};"
}
println "UPDATE person SET birth_year = 0 WHERE birth_year < 9;"
