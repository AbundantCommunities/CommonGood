/*
 * Load the id of every address of a given neighbourhood to geolocate_request
 *
 * Worked well 2020.1.1, CG v1.15.1
*/

INSERT INTO geolocate_request
SELECT a.id,
       a.version,
       a.id,
       CURRENT_TIMESTAMP
FROM address AS a,
     block AS b
WHERE a.block_id = b.id
AND   b.neighbourhood_id = REPLACE_WITH_NH_ID
