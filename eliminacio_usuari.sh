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
echo dades_normalitzades a fitxer dades_normalitzades.csv
echo dades_normalitzades a fitxer dades_normalitzades.csv > log.log 2>&1
while IFS=',' read -r campo1 campo2; do
    # Generar UID: primera lletra de campo1 + tot campo2
    first_char_campo1="${campo1:0:1}"
    nom_usuari="${first_char_campo1}${campo2}"
    if ldapsearch -x -H "$server_ldap" -b "ou=usuari,$base_dn" "cn=$nom_usuari" | grep -q "^dn:"; then
        echo "El usuari $nom_usuari existeix a LDAP"
    else
        echo "El usuari $nom_usuari no existeix a LDAP"