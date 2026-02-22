#!/bin/bash
base_dn="dc=tecnosolutions,dc=lan"
admin_dn="cn=admin,dc=tecnosolutions,dc=lan"
server_ldap="ldap://localhost:389"
dia_hora=$(date +%Y%m%d)
nom_fitxer_backup="backup_"$dia_hora".ldif"
bucket="backups-ldap"
remote="corporate_s3"
ldapsearch -x -H "$server_ldap" -D "cn=admin,dc=tecnosolutions,dc=lan" -w admin -LLL -b "$base_dn" > $nom_fitxer_backup
echo "Backup completat"

rclone copy "$nom_fitxer_backup" "${remote}:${bucket}/" --checksum --progress
RC=$?

if [ $RC -eq 0 ]; then
  echo " Còpia a S3 completada: $remote:$bucket/$nom_fitxer_backup"
else
  echo " Error en pujar a S3 (codi $RC): $remote:$bucket/$nom_fitxer_backup" >&2
fi
