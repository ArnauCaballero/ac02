#!/bin/bash
base_dn="dc=tecnosolutions,dc=lan"
admin_dn="cn=admin,dc=tecnosolutions,dc=lan"
server_ldap="ldap://localhost:389"
dia_hora=$(date +%Y%m%d_%H%M)
ldapsearch -x -H "$server_ldap" -D "cn=admin,dc=tecnosolutions,dc=lan" -w admin -LLL -b "$base_dn" > backup_"$dia_hora".ldif
echo "Backup completat"