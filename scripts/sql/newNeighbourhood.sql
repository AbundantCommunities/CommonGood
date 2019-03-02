/*
2018.11.21, CG v1.13.1

One way to create a new Neighbourhood.

In Bedford, create a new block, address, family and person, where the
person is the Neighbourhood Connector, NC. Make the person record
identify the NC, especially the email address. Take note of the person
id, say it is 77777. Also note the id of the block you made, say 66666.

Scan the neighbourhood table and choose a unique id, say 88888.
Insert a new row with the following statement.
*/
INSERT INTO neighbourhood( id, version, date_created, last_updated, logo, name, accept_anonymous_requests, email_anonymous_requests )
VALUES ( 88888, 0, CURRENT_DATE, CURRENT_DATE, null, 'Wakanda Community', TRUE, TRUE );

/* Pick some unused PKs for questions...
*/
INSERT INTO question( id, version, code, date_created, last_updated, neighbourhood_id, order_within_questionnaire, text, short_text )
VALUES( 1, 0, '1', CURRENT_DATE, CURRENT_DATE, 88888, 100, 'What is your vision for our neighbourhood?', 'Vision?');

INSERT INTO question( id, version, code, date_created, last_updated, neighbourhood_id, order_within_questionnaire, text, short_text )
VALUES( 2, 0, '2', CURRENT_DATE, CURRENT_DATE, 88888, 200, 'What interests or activities would you enjoy participating in with neighbours?', 'Participate?');

INSERT INTO question( id, version, code, date_created, last_updated, neighbourhood_id, order_within_questionnaire, text, short_text )
VALUES( 3, 0, '3', CURRENT_DATE, CURRENT_DATE, 88888, 300, 'What skills, abilities or experiences would you be willing to share with neighbours?', 'Share?');

/*  Move the new block from Bedford to the new neighbourhood.
*/
UPDATE block SET neighbourhood_id = 88888 where id = 66666;

/* Scan the domain_authorization table and choose a unique id, say 99999.
   Create a new DA row with the following statement.
*/
INSERT INTO domain_authorization( id, version, date_created, domain_code, domain_key, last_updated, person_id, primary_person, order_within_domain )
VALUES( 99999, 0, CURRENT_DATE, 'N', 88888, CURRENT_DATE, 77777, TRUE, 100 );
 
/* Update the person record.
*/
UPDATE person SET app_user = TRUE WHERE id = 77777;
