/*
2018.2.27, CG v1.12.1

person_id | email_address                                  | first_names | last_name       | nhid | name
----------+------------------------------------------------+-------------+-----------------+------+-------------------------------
     1201 | anonymous@example.org                          | Obscured    | Name            | 4200 | Alberta Avenue CL
     1200 | anonymous@example.org                          | Obscured    | Name            | 4200 | Alberta Avenue CL
    18923 | anonymous@example.org                          | Obscured    | Name            |  500 | Bannerman CL
      700 | anonymous@example.org                          | Obscured    | Name            |  500 | Bannerman CL
     7165 | anonymous@example.org                          | Obscured    | Name            |    1 | Bedford
*/
SELECT da.person_id,
       p.email_address,
       p.first_names,
       p.last_name,
       da.domain_key AS nhId,
       nh.name
FROM domain_authorization AS da,
     neighbourhood AS nh,
     person AS p
WHERE da.domain_code = 'N'
AND   da.domain_key = nh.id
AND   da.person_id = p.id
AND   da.write
ORDER BY nh.name

