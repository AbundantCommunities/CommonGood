/*
    Made-up data for Bonnie Doon, in order to test CommonGood features.
    Creates location-less blocks, a family with participate_in_interview false, etc.
*/

/* Make some family-less people who can stand in as block connectors */
INSERT INTO person(  id, version,  app_user,   birth_year,  date_created,  email_address,  family_id,  first_names,  last_name,  last_updated,  password_hash,  phone_number )
VALUES(  901,  0,  FALSE,  1901,  CURRENT_DATE,  'yl@abundantedmonton.ca',  NULL,  'Yvon',  'Leblanc',  CURRENT_DATE,  12345,  '123-456-7890' );

INSERT INTO person( id, version,  app_user,   birth_year,  date_created,  email_address,  family_id,  first_names,  last_name,  last_updated,  password_hash,  phone_number )
VALUES(  902,  0,  FALSE,  1902,  CURRENT_DATE,  'rryan@sunnydays.ca',  NULL,  'Ryan',  'Radke',  CURRENT_DATE,  22333,  '444-555-6666' );

INSERT INTO person( id, version,  app_user,   birth_year,  date_created,  email_address,  family_id,  first_names,  last_name,  last_updated,  password_hash,  phone_number )
VALUES(  903,  0,  FALSE,  1902,  CURRENT_DATE,  'angela@leanforward.ca',  NULL,  'Angela',  'Taylor',  CURRENT_DATE,  44555,  '780-434-6071' );


/* Make a location-less block (id 101, code BC55) */
INSERT INTO block( id, version, code, neighbourhood_id, order_within_neighbourhood, date_created, last_updated )
VALUES( 101, 0, 'BC55', 1, 99, CURRENT_DATE, CURRENT_DATE );


/* Make a family-less location for block code '8' which is block_id 13 */
INSERT INTO location( id, version, block_id, note, official_address, order_within_block )
VALUES( 801, 0, 13, 'note!', '9301-93 St', 5 );


/* Make a location for block code '8' which will receive a participate_in_interview value of false */
INSERT INTO location( id, version, block_id, note, official_address, order_within_block )
VALUES( 802, 0, 13, 'House is painted black', '9303-93 St', 7 );

INSERT INTO family( id, version, family_name, initial_interview_date, interviewer_id, location_id, participate_in_interview, permission_to_contact, primary_member_id )
VALUES( 601, 0, 'Grinch', CURRENT_DATE, 903, 802, FALSE, TRUE, NULL );

UPDATE family SET initial_interview_date = CURRENT_DATE - cast((random()*500) as integer);

/* Arbitrarily assign those 3 block connectors to bonnie doon's families */
UPDATE family
   SET interviewer_id = 901 +(id % 2)
WHERE id < 80;

UPDATE family
   SET interviewer_id = 903
WHERE id >= 80;

INSERT INTO domain_authorization( id, version, date_created, domain_code, domain_key, last_updated, person_id )
VALUES( 1, 0, CURRENT_DATE, 'B', 1, CURRENT_DATE, 901 );
INSERT INTO domain_authorization( id, version, date_created, domain_code, domain_key, last_updated, person_id )
VALUES( 2, 0, CURRENT_DATE, 'B', 2, CURRENT_DATE, 901 );
INSERT INTO domain_authorization(id, version, date_created, domain_code, domain_key, last_updated, person_id )
VALUES( 3, 0, CURRENT_DATE, 'B', 3, CURRENT_DATE, 901 );
INSERT INTO domain_authorization( id, version, date_created, domain_code, domain_key, last_updated, person_id )
VALUES( 4, 0, CURRENT_DATE, 'B', 4, CURRENT_DATE, 901 );
INSERT INTO domain_authorization( id, version, date_created, domain_code, domain_key, last_updated, person_id )
VALUES( 5, 0, CURRENT_DATE, 'B', 5, CURRENT_DATE, 901 );

INSERT INTO domain_authorization( id, version, date_created, domain_code, domain_key, last_updated, person_id )
VALUES( 6, 0, CURRENT_DATE, 'B', 6, CURRENT_DATE, 902 );
INSERT INTO domain_authorization( id, version, date_created, domain_code, domain_key, last_updated, person_id )
VALUES( 7, 0, CURRENT_DATE, 'B', 7, CURRENT_DATE, 902 );
INSERT INTO domain_authorization( id, version, date_created, domain_code, domain_key, last_updated, person_id )
VALUES( 8, 0, CURRENT_DATE, 'B', 8, CURRENT_DATE, 902 );
INSERT INTO domain_authorization( id, version, date_created, domain_code, domain_key, last_updated, person_id )
VALUES( 9, 0, CURRENT_DATE, 'B', 9, CURRENT_DATE, 902 );
INSERT INTO domain_authorization( id, version, date_created, domain_code, domain_key, last_updated, person_id )
VALUES( 10, 0, CURRENT_DATE, 'B', 10, CURRENT_DATE, 902 );

INSERT INTO domain_authorization( id, version, date_created, domain_code, domain_key, last_updated, person_id )
VALUES( 11, 0, CURRENT_DATE, 'B', 11, CURRENT_DATE, 903 );
INSERT INTO domain_authorization( id, version, date_created, domain_code, domain_key, last_updated, person_id )
VALUES( 12, 0, CURRENT_DATE, 'B', 12, CURRENT_DATE, 903 );
INSERT INTO domain_authorization( id, version, date_created, domain_code, domain_key, last_updated, person_id )
VALUES( 13, 0, CURRENT_DATE, 'B', 13, CURRENT_DATE, 903 );
INSERT INTO domain_authorization( id, version, date_created, domain_code, domain_key, last_updated, person_id )
VALUES( 14, 0, CURRENT_DATE, 'B', 14, CURRENT_DATE, 903 );
INSERT INTO domain_authorization( id, version, date_created, domain_code, domain_key, last_updated, person_id )
VALUES( 15, 0, CURRENT_DATE, 'B', 101, CURRENT_DATE, 903 );

/* Not Bonnie Doon related but still useful. */
INSERT INTO neighbourhood VALUES( 99, 0, current_date, current_date, null, 'Sunnyvale' );
