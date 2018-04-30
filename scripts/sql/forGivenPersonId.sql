/*
2018.3.14, CG v1.12.1

id   | name           | id   | code | id   | address    | id   | family       | id   | first_names | last_name
-----+----------------+------+------+------+------------+------+--------------+------+-------------+----------
2000 | Bonnie Doon CL | 2013 | 10   | 9768 | 9301 93 St | 9769 | Gordon/Hurst | 2000 | Mark        | Gordon   
*/
SELECT neighbourhood.id,
       neighbourhood.name,
       block.id,
       block.code,
       address.id,
       address.text AS address,
       family.id,
       family.name AS family,
       person.id,
       person.first_names,
       person.last_name
FROM neighbourhood,
     block,
     address,
     family,
     person
WHERE neighbourhood.id = block.neighbourhood_id
AND   block.id = address.block_id
AND   address.id = family.address_id
AND   family.id = person.family_id
AND   person.id = 2000
