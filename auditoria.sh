#!/bin/bash
base_dn="dc=tecnosolutions,dc=lan"
admin_dn="cn=admin,dc=tecnosolutions,dc=lan"
server_ldap="ldap://localhost:389"
ldapsearch -x -H "$server_ldap" -D "cn=admin,dc=tecnosolutions,dc=lan" -w admin -LLL -b "ou=usuaris,$base_dn" objectclass=posixaccount dn > informe_data.txt
numero_usuaris=$(grep -cve "^\s*$" informe_data.txt)
echo "Recompte total d'usuaris al sistema es de $numero_usuaris" > informe_data.txt
cat informe_data.txt
ldapsearch -x -H "$server_ldap" -D "cn=admin,dc=tecnosolutions,dc=lan" -w admin -LLL -b "ou=comptabilitat,ou=usuaris,$base_dn" objectclass=posixaccount dn > informe_data.txt
numero_usuaris=$(grep -cve "^\s*$" informe_data.txt)
echo "Recompte total d'usuaris al sistema es de $numero_usuaris" > informe_data.txt
cat informe_data.txt
ldapsearch -x -H "$server_ldap" -D "cn=admin,dc=tecnosolutions,dc=lan" -w admin -LLL -b "ou=direccio,ou=usuaris,$base_dn" objectclass=posixaccount dn > informe_data.txt
numero_usuaris=$(grep -cve "^\s*$" informe_data.txt)
echo "Recompte total d'usuaris al sistema es de $numero_usuaris" > informe_data.txt
cat informe_data.txt
ldapsearch -x -H "$server_ldap" -D "cn=admin,dc=tecnosolutions,dc=lan" -w admin -LLL -b "ou=marketing,ou=usuaris,$base_dn" objectclass=posixaccount dn > informe_data.txt
numero_usuaris=$(grep -cve "^\s*$" informe_data.txt)
echo "Recompte total d'usuaris al sistema es de $numero_usuaris" > informe_data.txt
cat informe_data.txt
ldapsearch -x -H "$server_ldap" -D "cn=admin,dc=tecnosolutions,dc=lan" -w admin -LLL -b "ou=sistemes,ou=usuaris,$base_dn" objectclass=posixaccount dn > informe_data.txt
numero_usuaris=$(grep -cve "^\s*$" informe_data.txt)
echo "Recompte total d'usuaris al sistema es de $numero_usuaris" > informe_data.txt
cat informe_data.txt
ldapsearch -x -H "$server_ldap" -D "cn=admin,dc=tecnosolutions,dc=lan" -w admin -LLL -b "ou=vendes,ou=usuaris,$base_dn" objectclass=posixaccount dn > informe_data.txt
numero_usuaris=$(grep -cve "^\s*$" informe_data.txt)
echo "Recompte total d'usuaris al sistema es de $numero_usuaris" > informe_data.txt
cat informe_data.txt