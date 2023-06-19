#!/bin/bash

if [ "$DUPLICATI__EVENTNAME" == "BEFORE" ]
then
	if [ "$DUPLICATI__OPERATIONNAME" == "Backup" ]
	then
		echo "BEFORE docker command to do backup"
		docker exec mariadb_$DUPLICATI__backup_name mysqldump --opt --no-autocommit --user root --password=$DB_PASSWORD twomes > /dump_$DUPLICATI__backup_name/db.dump
		echo "AFTER docker command to do backup"
	fi

elif [ "$DUPLICATI__EVENTNAME" == "AFTER" ]
then

        if [ "$DUPLICATI__OPERATIONNAME" == "Restore" ]
        then
                echo "BEFORE docker command to do Restore"
                docker exec -i mariadb_$DUPLICATI__backup_name mysql --user root --password=$DB_PASSWORD twomes < /dump_$DUPLICATI__backup_name/db.dump
		echo "AFTER docker command to do Restore"
        fi
fi

exit 0
