/*
2018.2.27, CG v1.12.1

short_text        | text
------------------+----------------------------------------------------------------------------------
Makes a great NH  | Accessibility
Makes a great NH  | Central location
Makes a great NH  | Centrality
Makes a great NH  | Community
Makes a great NH  | Community
Makes a great NH  | Diversity

*/
SELECT question.short_text,
       answer.text
FROM answer,
     question
WHERE answer.question_id = question.id
AND   question.neighbourhood_id = 2000
ORDER BY question.id,
         answer.text
