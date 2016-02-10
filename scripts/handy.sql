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
