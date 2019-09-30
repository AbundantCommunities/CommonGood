/*
 * These statements merged Dovercourt CL's questions and answers from the 6-question questionnaire
 * to the 3-question one. Also, note that the "gifts" question becomes the middle question instead of
 * being at the last question.
 *
 * WARNING. Of course, these id references worked for Dovercourt. Other neighbourhoods have different
 * id values!
 */

UPDATE answer SET question_id = 351 WHERE question_id = 352;
UPDATE answer SET question_id = 353 WHERE question_id = 354;
UPDATE answer SET question_id = 355 WHERE question_id = 356;

delete from question where id = 352;
delete from question where id = 354;
delete from question where id = 356;

update question set code = 2, order_within_questionnaire = 200 where id = 355;

