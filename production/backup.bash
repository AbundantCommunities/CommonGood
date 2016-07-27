#!/usr/bin/env bash
# crontab -l
# @hourly ~/backup/backup.bash

cd ~/backup
pg_dump --format=c --disable-triggers thehoods > database.dmp
openssl smime -encrypt -aes256 -binary -outform DEM -out database.dmp.encrypted backup_key.pem.pub < database.dmp

openssl smime -encrypt -aes256 -binary -outform DEM -out fullchain_and_key.p12.encrypted backup_key.pem.pub < ~/fullchain_and_key.p12

sudo tar zcf letsencrypt.tgz --directory /etc letsencrypt
openssl smime -encrypt -aes256 -binary -outform DEM -out letsencrypt.tgz.encrypted backup_key.pem.pub < letsencrypt.tgz
rm --force letsencrypt.tgz
