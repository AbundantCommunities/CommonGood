Long lowId = Long.parseLong( args[0] )
Long highId = Long.parseLong( args[1] )

def names = ['Abbot Dr','Beaumont Ave','Chimera Ln','Danforth Cres','Eddington St',\
            'Frank Ave','Gifford St','High St','Woodland Ave','Victoria Ave',
            'Ravine View Dr','Spruce St','Old Mill Ln','Debussy Ave','Thierry Cres'].sort( )

def zaq = """\n\
UPDATE location SET official_address= RND cat '${rName}' WHERE block_id=1;
"""


for( id in lowId..highId ) {
    rNbr  = new Random().nextInt(125)
    rName = names[ new Random().nextInt(names.size()) ]
    rType = types[ new Random().nextInt(types.size()) ]
    println "UPDATE location SET official_address='${rNbr} ${rName} ${rType}' WHERE id=${id};"
}