#!/bin/bash

'''
\/\/\/\/\/\/\/\ Backup do Servidor de Arquivos - Espelhamento /\/\/\/\/\/\/\/\

\... Michael Martins - 2022
    \... https://github.com/michaelrmartins
    \... https://github.com/michaelrmartins/server_backup-sh

- Faz backup da pasta de arquivos.
- Faz backup do tipo "Espelhamento".

> Changelog
28/12/2022 - Criação
29/12/2022 - Correção de bug de permissões
09/02/2023 - Adicionada a função de espelhamento da pasta compartilhamentos e usuarios
'''
#Global
day=`TZ='America/Sao_Paulo' date +%d`
month=`TZ='America/Sao_Paulo' date +%m-%B`
year=`TZ='America/Sao_Paulo' date +%Y`
folderName=`TZ='America/Sao_Paulo' date +%d%m%Y`
logDate=`TZ='America/Sao_Paulo' date +%d/%m/%Y-%H:%M:%S`

# Destination Server parameters
server="192.168.0.218"
destinationFolderCompartilhamentos="/media/raid10tb/backup_arquivos/espelhamento/compartilhamentos/"
destinationFolderUsuarios="/media/raid10tb/backup_arquivos/espelhamento/usuarios/"

#Source Folders Parameters
sourceFolderCompartilhamentos="/home/compartilhamentos/"
sourceFolderUsuarios="/home/usuarios/"

# Log Parameters
logFolder="/var/log/server_backup-sh"
logFile="server_backup-mirror.log"

# Begin !!!
cd /usr/bin
echo "-----------------------------------">>$logFolder/$logFile
echo "`TZ='America/Sao_Paulo' date +%d/%m/%Y-%H:%M:%S` - Espelhamento da pasta CompartilhamentosIniciado">>$logFolder/$logFile

# rsync command / Full Patch are necessary because cron can't work properly using local file path reference
# mirror "compartilhamentos" begin!
rsync -vaz -e "ssh -i /root/.ssh/id_rsa" --exclude-from='/home/server_backup-sh/exclude_list.txt' --delete --delete-excluded --recursive $sourceFolderCompartilhamentos root@$server:$destinationFolderCompartilhamentos>>$logFolder/$logFile
echo "`TZ='America/Sao_Paulo' date +%d/%m/%Y-%H:%M:%S` - Espelhamento da Usuarios CompartilhamentosIniciado">>$logFolder/$logFile
# mirror "usuarios" begin!
rsync -vaz -e "ssh -i /root/.ssh/id_rsa" --exclude-from='/home/server_backup-sh/exclude_list.txt' --delete --delete-excluded --recursive $sourceFolderUsuarios root@$server:$destinationFolderUsuarios>>$logFolder/$logFile
echo "`TZ='America/Sao_Paulo' date +%d/%m/%Y-%H:%M:%S` - Espelhamento Finalizado">>$logFolder/$logFile
echo ".">>$logFolder/$logFile