Long lowId = Long.parseLong( args[0] )
Long highId = Long.parseLong( args[1] )

emailServers = ['gmail.com','hotmail.com','yahoo.ca','shaw.ca','rogers.com','telus.ca','bell.ca']

for( id in lowId..highId ) {
    base = new Random().nextInt(10000000) + 10000000 + ''
    extract = base[-6..-1]
    rPhone = '519-4' + extract[0..1] + '-' + extract[2..-1]
    rServer = emailServers[new Random().nextInt(emailServers.size())]
    rEmail = new Random().nextInt(1000) + '@' + rServer
    println "UPDATE person SET phone_number='${rPhone}', email_address=last_name||'${rEmail}' WHERE id=${id};"
}