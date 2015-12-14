/*
CREATE USER myapp PASSWORD 'sloj92GOM';
CREATE DATABASE thehoods WITH OWNER myapp;
DROP DATABASE thehoods;
*/

/* These delete statements are in the right order...
DELETE FROM answer;
UPDATE family SET primary_member_id = NULL;
UPDATE family SET interviewer_id = NULL;
UPDATE domain_authorization SET person_id = NULL;
DELETE FROM person;
DELETE FROM family;
DELETE FROM location;
DELETE FROM block;
DELETE FROM question;
DELETE FROM neighbourhood;
DELETE FROM this_installation;
*/

/* Ignoring case, see all unique answer strings */
SELECT DISTINCT lower(text) AS ltext
FROM answer
WHERE question_code = 1
ORDER BY ltext;

