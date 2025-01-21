#!/bin/bash

DB_USER="jokedbuser"              
DB_PASSWORD="123456"      
DB_NAME="jokedb"   
BACKUP_DIR="/mnt/backup"    
DATE=$(date +"%Y-%m-%d_%H-%M-%S")
DUMP_FILE="mysql_backup_${DB_NAME}_${DATE}.sql"
ARCHIVE_FILE="${DUMP_FILE}.tar.gz"

if [ ! -d "$BACKUP_DIR" ]; then
    echo "Backup-Verzeichnis $BACKUP_DIR existiert nicht. Bitte mounten oder erstellen."
    exit 1
fi


echo "Erstelle MySQL-Dump..."
mysqldump -u "$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" > "/tmp/$DUMP_FILE"
if [ $? -ne 0 ]; then
    echo "Fehler beim Erstellen des MySQL-Dumps."
    exit 1
fi
echo "MySQL-Dump erstellt: /tmp/$DUMP_FILE"

echo "Komprimiere Dump..."
tar -czf "/tmp/$ARCHIVE_FILE" -C /tmp "$DUMP_FILE"
if [ $? -ne 0 ]; then
    echo "Fehler beim Komprimieren des Dumps."
    exit 1
fi
echo "Dump komprimiert: /tmp/$ARCHIVE_FILE"

echo "Verschiebe Archiv nach $BACKUP_DIR..."
mv "/tmp/$ARCHIVE_FILE" "$BACKUP_DIR/"
if [ $? -ne 0 ]; then
    echo "Fehler beim Verschieben des Archivs."
    exit 1
fi

rm "/tmp/$DUMP_FILE"

echo "Backup abgeschlossen. Archiv gespeichert unter $BACKUP_DIR/$ARCHIVE_FILE"
