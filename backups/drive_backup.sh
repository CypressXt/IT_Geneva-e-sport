#!/bin/bash
# Google Drive Sync

# Autor: Clément hampaï <clement.hampai@cypressxt.net>
# Config BEGIN
# =====================================================================

# Zipping the directory to backup
backup_name="backup_"$(date +'%m_%d_%Y')".zip"
zip -r /tmp/"$backup_name" /var/www/

# Directory to backup
BACKUPZIP=/tmp/"$backup_name"

# =====================================================================
# Config END

# Coping new content
drive upload -p 0B_Y7zEMh3vaISllnV3JhaGFCcFU --file ${BACKUPZIP}

/home/cypress/cyprxt_backup.sh "${BACKUPZIP}"

rm ${BACKUPZIP}
