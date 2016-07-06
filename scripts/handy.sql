/*
On your TEST DATABASE ONLY, set everyone's password hash to shh
UPDATE person SET hashed_password =
'PBKDF2WithHmacSHA512|75000|64|256|o6auh3NPvmO/E5uLDV2AGxyDj7J6pBtc+kFrAUVt8QbKc40sx8w9/qpnh3x1V1HxgHhNXCrpuPmADqQiY8DX5w==|QK1tbv8gYSgcq6zddVFHI6XaVYKb5K9SAGuC4jHuOes=';
*/

/*
CREATE USER myapp PASSWORD 'sloj92GOM';
CREATE DATABASE thehoods WITH OWNER myapp;
DROP DATABASE thehoods;
*/

/* These delete statements are in the right order...
DELETE FROM answer;
UPDATE family SET interviewer_id = NULL;
DELETE FROM domain_authorization;
DELETE FROM person;
DELETE FROM family;
DELETE FROM address;
DELETE FROM block;
DELETE FROM question;
DELETE FROM neighbourhood;
DELETE FROM this_installation;

ALTER SEQUENCE hibernate_sequence RESTART WITH 7000;
*/

SELECT COUNT(*) FROM address;
SELECT COUNT(*) FROM answer;
SELECT COUNT(*) FROM block;
SELECT COUNT(*) FROM domain_authorization;
SELECT COUNT(*) FROM family;
SELECT COUNT(*) FROM neighbourhood;
SELECT COUNT(*) FROM person;
SELECT COUNT(*) FROM question;
SELECT COUNT(*) FROM this_installation;

SELECT MAX(id) FROM address;
SELECT MAX(id) FROM answer;
SELECT MAX(id) FROM block;
SELECT MAX(id) FROM domain_authorization;
SELECT MAX(id) FROM family;
SELECT MAX(id) FROM neighbourhood;
SELECT MAX(id) FROM person;
SELECT MAX(id) FROM question;
SELECT MAX(id) FROM this_installation;

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



/* Useful for setting up a new neighbourhood

INSERT INTO neighbourhood( id, version, date_created, last_updated, logo, name )
VALUES( AAAAA, 0, CURRENT_DATE, CURRENT_DATE, NULL, '* NAME OF NEIGHBOURHOOD *' );

INSERT INTO block( id, version, code, date_created, description, last_updated, neighbourhood_id, order_within_neighbourhood )
VALUES( KKKKK, 0, '1', CURRENT_DATE, 'Describe the block', CURRENT_DATE, AAAAA, 100 );

INSERT INTO address( id, version, block_id, date_created, last_updated, note, order_within_block, text )
VALUES( WWWWW, 0, KKKKK, CURRENT_DATE, CURRENT_DATE, '(note)', 100, '* ADDRESS OF NC *');

INSERT INTO family( id, version, address_id, date_created, interview_date, interviewer_id, last_updated, name, note, order_within_address, participate_in_interview, permission_to_contact )
VALUES( XXXXX, 0, WWWWW, CURRENT_DATE, CURRENT_DATE, NULL, CURRENT_DATE, '* NC SURNAME *', '(note)', 100, TRUE, TRUE);

INSERT INTO person( id, version, app_user, birth_year, date_created, email_address, family_id, first_names, last_name, last_updated, order_within_family, phone_number, note, hashed_password )
VALUES( YYYYY, 0, TRUE, 0, CURRENT_DATE, 'stewcarson@shaw.ca', XXXXX, '* GIVEN NAMES *', '* SURNAME *', CURRENT_DATE, 100, '999-999-9999', '(note)', '* BAD HASH *' );

INSERT INTO domain_authorization( id, version, date_created, domain_code, domain_key, last_updated, person_id, primary_person, order_within_domain )
VALUES( ZZZZZ, 0, CURRENT_DATE, 'N', AAAAA, CURRENT_DATE, YYYYY, false, 100 );

INSERT INTO question( id, version, code, date_created, last_updated, neighbourhood_id, order_within_questionnaire, text, short_text )
VALUES( QQQQQ, 0, '1', CURRENT_DATE, CURRENT_DATE, AAAAA, 100, 'What makes a great neighbourhood?', 'Great NH?');
*/