String nameFile = args[0]
Long lowId = Long.parseLong( args[1] )
Long highId = Long.parseLong( args[2] )
String table = args[3]
String column = args[4]

println "Take names from this file: ${nameFile}"
println "Generate id values from ${lowId} to ${highId}"
println "Update column ${table}.${column}"
println ''

def names = [ ]
new File( nameFile ).eachLine {
    names << it
}

for( id in lowId..highId ) {
    randomName = names[ new Random().nextInt(names.size()) ]
    println "UPDATE ${table} SET ${column}='${randomName}' WHERE id=${id};"
}