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
day=`date +%d`
month=`date +%m-%B`
year=`date +%Y`
folderName=`date +%d%m%Y`
logDate=`date +%d/%m/%Y-%H:%M:%S`

# Destination Server
server="192.168.0.218"

# Destination Folder
destinationFolder="/media/raid10tb/backup_arquivos/espelhamento/"

# sourceFolder
sourceFolder="/home/compartilhamentos/"

# Log Folder
logFolder="/var/log/server_backup-sh"

# Log File Name
logFileName="server_backup-mirror.log"

# rsync command
rsync -vaz --exclude-from='exclude_list.txt' --delete --recursive $sourceFolder root@$server:$destinationFolder