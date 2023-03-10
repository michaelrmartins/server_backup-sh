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
09/02/2023 - Adicionada a função de backup da pasta de usuários e setores simultaneamente
'''

#Global
day=`TZ='America/Sao_Paulo' date +%d`
month=`TZ='America/Sao_Paulo' date +%m-%B`
year=`TZ='America/Sao_Paulo' date +%Y`
zipFileNameCompartilhamentos="programas_`TZ='America/Sao_Paulo' date +%d%m%Y`"
zipFileNameUsuarios="usuarios_`TZ='America/Sao_Paulo' date +%d%m%Y`"
logDate=`TZ='America/Sao_Paulo' date +%d/%m/%Y-%H:%M:%S`

# Rsync Destination Server parameters
server="192.168.0.218"
destinationFolderCompartilhamentos="/media/raid10tb/backup_arquivos/backup_total_diario/compartilhamentos"
destinationFolderUsuarios="/media/raid10tb/backup_arquivos/backup_total_diario/usuarios"
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
echo "`TZ='America/Sao_Paulo' date +%d/%m/%Y-%H:%M:%S` - Backup Total Iniciado">>$logFolder/$logFile
echo "`TZ='America/Sao_Paulo' date +%d/%m/%Y-%H:%M:%S` - Compactando arquivos">>$logFolder/$logFile

# Zip Command  / Full Patch are necessary because cron can't work properly using local file path reference
zip -r -y -0 -T -x@/home/server_backup-sh/exclude_list.txt /tmp/$zipFileNameCompartilhamentos.zip /home/compartilhamentos
zip -r -y -0 -T -x@/home/server_backup-sh/exclude_list.txt /tmp/$zipFileNameUsuarios.zip /home/usuarios
echo "`TZ='America/Sao_Paulo' date +%d/%m/%Y-%H:%M:%S` - Compactação Finalizada, checando integridade">>$logFolder/$logFile
echo "`TZ='America/Sao_Paulo' date +%d/%m/%Y-%H:%M:%S` - Ok">>$logFolder/$logFile
echo "`TZ='America/Sao_Paulo' date +%d/%m/%Y-%H:%M:%S` - Enviando arquivo para o Servidor de Backup $server">>$logFolder/$logFile

# Sending file to Server
rsync --progress -e "ssh -i /root/.ssh/id_rsa" $sourceFolder/$zipFileNameCompartilhamentos.zip root@$server:$destinationFolderCompartilhamentos>>$logFolder/$logFile
rsync --progress -e "ssh -i /root/.ssh/id_rsa" $sourceFolder/$zipFileNameUsuarios.zip root@$server:$destinationFolderUsuarios>>$logFolder/$logFile

# Clean and Exit...
echo "`TZ='America/Sao_Paulo' date +%d/%m/%Y-%H:%M:%S` - Transferencia Finalizada">>$logFolder/$logFile
echo "`TZ='America/Sao_Paulo' date +%d/%m/%Y-%H:%M:%S` - Removendo arquivos temporarios">>$logFolder/$logFile
rm /tmp/*.zip
echo "`TZ='America/Sao_Paulo' date +%d/%m/%Y-%H:%M:%S` - Backup Total Finalizado">>$logFolder/$logFile