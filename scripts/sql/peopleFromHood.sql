/*
2018.3.14, CG v1.12.1

first_names | last_name   | name           | text                | code 
------------+-------------+----------------+---------------------+------
Everett     | Nixon       | Gaines         | 100 Eddington Ave   | 14   
Kristy      | Terry       | Gaines         | 100 Eddington Ave   | 14   
Muriel      | Gordon      | Woodward       | 119 Abbot St        | 14   
Micheal     | Alvarado    | Woodward       | 119 Abbot St        | 14   
*/
SELECT person.first_names,
       person.last_name,
       family.name,
       address.text,
       block.code
FROM person,
     family,
     address,
     block
WHERE person.family_id = family.id
AND   family.address_id = address.id
AND   address.block_id = block.id
AND   block.neighbourhood_id = 1
