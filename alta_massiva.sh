#!/bin/bash
base_dn="dc=tecnosolutions,dc=lan"
admin_dn="cn=admin,dc=tecnosolutions,dc=lan"
server_ldap="ldap://localhost:389"
fitxer_csv=""
while getopts "r:" opt; do
  case $opt in
    r) fitxer_csv="$OPTARG" ;;
    *)
      echo "Ús: $0 -r fitxer.csv"
      exit 1
      ;;
  esac
done
if [ -z "$fitxer_csv" ]; then
  echo "Error: falten paràmetres"
  echo "Ús: $0 -r fitxer.csv"
  exit 1
fi
# Funció per normalitzar text (treure majúscules i accents)
# Ús: normalitzar_text <fitxer.csv>
function normalitzar_text {
    cat "$1" | \
    tr '[:upper:]' '[:lower:]' | \
    sed 's/[àáäâ]/a/g; s/[èéëê]/e/g; s/[ìíïî]/i/g; s/[òóöô]/o/g; s/[ùúüû]/u/g; s/ç/c/g; s/ñ/n/g'
}
# Exemple (pots cridar la funció així):
# normalitzar_text "dades.csv" > "dades_normalitzades.csv"
normalitzar_text "$fitxer_csv" > "dades_normalitzades.csv"
sed -i '1d' "dades_normalitzades.csv"

> grups.ldif
declare -A tipus_vistos
gid_counter=20000

while IFS=',' read -r campo1 campo2 campo3 campo4; do
    if [[ -z "${tipus_vistos[$campo3]}" ]]; then
        # Comprovar si el grup existeix a LDAP
        if ldapsearch -x -H ldap://192.168.17.95 -b "ou=grups,$base_dn" "cn=$campo3" | grep -q "^dn:"; then
            echo "El grup $campo3 ja existeix a LDAP. No s'afegeix."
        else
            cat <<EOF >> grups.ldif
dn: cn=$campo3,ou=grups,$base_dn
objectClass: top
objectClass: posixGroup
cn: $campo3
gidNumber: $gid_counter
description: Grup $campo3

EOF
            echo "S'ha creat el grup $campo3 a grups.ldif"
            ((gid_counter++))
        fi
        tipus_vistos[$campo3]=1
    fi
done < "dades_normalitzades.csv"

if [ -s "grups.ldif" ]; then
    echo "Afegint els grups a LDAP..."
    ldapadd -x -H "$server_ldap" -D "$admin_dn" -w "admin" -f ./grups.ldif
else
    echo "No s'han trobat grups nous per afegir."
fi

> usuaris.ldif
uid_counter=10000

while IFS=',' read -r campo1 campo2 campo3 campo4; do
    # Generar UID: primera lletra de campo1 + tot campo2
    first_char_campo1="${campo1:0:1}"
    nom_usuari="${first_char_campo1}${campo2}"

    # 1. Grup privat de l'usuari (CN = UID)
    cat <<EOF >> usuaris.ldif
dn: cn=$nom_usuari,ou=grups,$base_dn
objectClass: top
objectClass: posixGroup
cn: $nom_usuari
gidNumber: $uid_counter
description: Grup privat de $nom_usuari

EOF

    # 2. Usuari
    # El gidNumber és el del seu grup privat ($gid_counter)
    cat <<EOF >> usuaris.ldif
dn: uid=$nom_usuari,ou=usuaris,$base_dn
objectClass: top
objectClass: person
objectClass: posixAccount
objectClass: shadowAccount
cn: $nom_usuari
sn: $campo2
uid: $nom_usuari
uidNumber: $uid_counter
gidNumber: $uid_counter
homeDirectory: /home/$nom_usuari
loginShell: /bin/bash
userPassword: {SSHA}password

EOF

    # 3. Afegir usuari al grup del camp3 (memberUid)
    cat <<EOF >> usuaris.ldif
dn: cn=$campo3,ou=grups,$base_dn
changetype: modify
add: memberUid
memberUid: $nom_usuari

EOF

    ((uid_counter++))
    ((gid_counter++))
done < "dades_normalitzades.csv"

if [ -s "usuaris.ldif" ]; then
    echo "Afegint usuaris i membres a LDAP..."
    ldapadd -x -H "$server_ldap" -D "$admin_dn" -w "admin" -f usuaris.ldif
else
    echo "No s'han trobat usuaris per afegir."
fi