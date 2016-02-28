#!/usr/bin/env bash
# crontab -l
# @hourly ~/backup/backup.bash

cd ~/backup
pg_dump --format=c --disable-triggers thehoods > database.dmp
openssl smime -encrypt -aes256 -binary -outform DEM -out database.dmp.encrypted backup_key.pem.pub < database.dmp
