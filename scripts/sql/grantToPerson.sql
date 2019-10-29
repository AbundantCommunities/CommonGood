/*
 * Grants person NC+write privilege. After this script, person has to use "reset password" feature.
 * Worked well 2019.10.25, CG v1.15.1
*/
UPDATE person
SET app_user = TRUE
WHERE id = 44308
AND   last_name = 'Meadows';

/* 4300 is neighbourhood.id for Windsor Park */
INSERT INTO domain_authorization(   id,  version,  date_created,  domain_code,  domain_key,  last_updated,  person_id,  primary_person,  order_within_domain,  write)
VALUES (  10,  0,  TIMESTAMP '2019-10-25 09:15:00',  'N',  4300,  TIMESTAMP '2019-10-25 09:15:00',  44308,  false,  120,  TRUE);
