#!/bin/bash

'''
\/\/\/\/\/\/\/\ Backup do Servidor de Arquivos - Backup Completo /\/\/\/\/\/\/\/\

\... Michael Martins - 2022 
    \... https://github.com/michaelrmartins
    \... https://github.com/michaelrmartins/server_backup-sh

- Faz backup da pasta de arquivos.
- Faz backup do tipo "Completo".

> Changelog
28/12/2022 - Criação
29/12/2022 - Correção de bug de permissões
'''
#Global
day=`TZ='America/Sao_Paulo' date +%d`
month=`TZ='America/Sao_Paulo' date +%m-%B`
year=`TZ='America/Sao_Paulo' date +%Y`
zipFileName=`TZ='America/Sao_Paulo' date +%d%m%Y`
logDate=`TZ='America/Sao_Paulo' date +%d/%m/%Y-%H:%M:%S`

# Rsync Destination Server parameters
server="192.168.0.218"
destinationFolder="/media/raid10tb/backup_arquivos/backup_total_diario/"
sourceFolder="/tmp/"

# Log Parameters
logFolder="/var/log/server_backup-sh"
logFile="server_backup-full.log"

# Check if Log directory Exists 
if [ ! -d $logFolder ]; then
    mkdir -p $logFolder
fi 

# Backup Begin!!!
echo "-----------------------------------">>$logFolder/$logFile
echo "$logDate - Backup Total Iniciado">>$logFolder/$logFile
echo "$logDate - Compactando arquivos">>$logFolder/$logFile

# Zip Command
zip -r -y -9 -T -x@exclude_list.txt /tmp/$zipFileName.zip /home/compartilhamentos
echo "$logDate - Compactação Finalizada, checando integridade">>$logFolder/$logFile
echo "$logDate - Ok">>$logFolder/$logFile
echo "$logDate - Enviando arquivo para o Servidor de Backup $server">>$logFolder/$logFile

# Sending file to Server
rsync --progress $sourceFolder/$zipFileName.zip root@$server:$destinationFolder>>$logFolder/$logFile

# Clean and Exit...
echo "$logDate - Transferência Finalizada">>$logFolder/$logFile
echo "$logDate - Removendo arquivos temporários">>$logFolder/$logFile
rm /tmp/*.zip
echo echo "$logDate - Backup Total Finalizado">>$logFolder/$logFile
