
/* Force "next primary key" to some value
       ALTER SEQUENCE hibernate_sequence RESTART WITH 7000;
*/


/*  All the Neighbourhood Connectors, sorted by NH Name  */
SELECT nh.name,
       p.first_names,
       p.last_name
FROM domain_authorization AS da,
     neighbourhood AS nh,
     person AS p
WHERE da.person_id = p.id
AND   da.domain_key = nh.id
AND   da.domain_code = 'N'
ORDER BY nh.name


/*  All people who can login to CG,
    sorted by neighbourhood and 'type' (BC or NC).
 */
(SELECT nh.name AS nh_name,
       ' ' AS block,
       'N' AS nc_or_bc,
       p.first_names,
       p.last_name,
       p.id AS p_id
FROM domain_authorization AS da,
     neighbourhood AS nh,
     person AS p
WHERE da.person_id = p.id
AND   p.app_user = TRUE
AND   da.domain_key = nh.id
AND   da.domain_code = 'N')
UNION
(SELECT nh.name AS nh_name,
       b.description AS block,
       'B' AS nc_or_bc,
       p.first_names,
       p.last_name,
       p.id AS p_id
FROM domain_authorization AS da,
     block AS b,
     neighbourhood AS nh,
     person AS p
WHERE da.person_id = p.id
AND   p.app_user = TRUE
AND   da.domain_code = 'B'
AND   da.domain_key = b.id
AND   b.neighbourhood_id = nh.id)
ORDER BY nh_name,
         nc_or_bc,
         first_names,
         last_name,
         p_id


SELECT COUNT(*) FROM address;
SELECT COUNT(*) FROM answer;
SELECT COUNT(*) FROM block;
SELECT COUNT(*) FROM domain_authorization;
SELECT COUNT(*) FROM family;
SELECT COUNT(*) FROM neighbourhood;
SELECT COUNT(*) FROM person;
SELECT COUNT(*) FROM question;
SELECT COUNT(*) FROM this_installation;
