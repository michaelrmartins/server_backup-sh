#!/bin/bash

'''
\/\/\/\/\/\/\/\ Backup do Servidor de Arquivos - Espelhamento /\/\/\/\/\/\/\/\

\... Michael Martins - 2022 
    \.... https://github.com/michaelrmartins

- Faz backup da pasta de arquivos.
- Faz backup do tipo "Espelhamento".

> Changelog
28/12/2022 - Criação
29/12/2022 - Correção de bug de permissões
'''
#Global
day=`TZ='America/Sao_Paulo' date +%d`
month=`TZ='America/Sao_Paulo' date +%m-%B`
year=`TZ='America/Sao_Paulo' date +%Y`
folderName=`TZ='America/Sao_Paulo' date +%d%m%Y`
logDate=`TZ='America/Sao_Paulo' date +%d/%m/%Y-%H:%M:%S`

# Destination Server parameters
server="192.168.0.218"
destinationFolder="/media/raid10tb/backup_arquivos/espelhamento/"
sourceFolder="/home/compartilhamentos/"

# Log Parameters
logFolder="/var/log/server_backup-sh"
logFile="server_backup-mirror.log"

# Check if Log directory Exists 
if [ ! -d $logFolder ]; then
    mkdir -p $logFolder
fi 

echo "-----------------------------------">>$logFolder/$logFile
echo "$logDate - Espelhamento Iniciado">>$logFolder/$logFile
# rsync command
rsync -vaz --exclude-from='exclude_list.txt' --delete --recursive $sourceFolder root@$server:$destinationFolder>>$logFolder/$logFile
echo "$logDate - Espelhamento Finalizado">>$logFolder/$logFile
echo ".">>$logFolder/$logFile