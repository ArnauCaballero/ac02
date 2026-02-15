#!/bin/bash
while true
do
    clear
    echo "--------------------------------"
    echo "   EINA DE GESTIÓ SYSADMIN"
    echo "--------------------------------"
    echo "1. Donar d'alta usuaris (CSV)"
    echo "2. Donar de baixa usuaris (CSV)"
    echo "3. Generar informe d'auditoria"
    echo "4. Fer Backup ara"
    echo "5. Sortir"
    echo "--------------------------------"
    read -p "Selecciona una opció: " opcio

    case $opcio in
        1)
            echo "Executant alta d'usuaris..."
            ./alta_massiva.sh
            read -p "Prem ENTER per continuar..."
            ;;
        2)
            echo "Executant baixa d'usuaris..."
            ./eliminacio_usuari.sh
            read -p "Prem ENTER per continuar..."
            ;;
        3)
            echo "Generant informe d'auditoria..."
            ./auditoria.sh
            read -p "Prem ENTER per continuar..."
            ;;
        4)
            echo "Executant backup..."
            ./backup_ldap.sh
            read -p "Prem ENTER per continuar..."
            ;;
        5)
            echo "Sortint del programa..."
            exit 0
            ;;
        *)
            echo "Opció no vàlida!"
            read -p "Prem ENTER per continuar..."
            ;;
    esac
done
