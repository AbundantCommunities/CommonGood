UPDATE person
   SET app_user = FALSE,
       last_updated = CURRENT_TIMESTAMP,
       hashed_password = ''
WHERE id = 23337
