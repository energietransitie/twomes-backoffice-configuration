#!/bin/bash
if [ "$DUPLICATI__backup_name" == "dev" ]
then
        DB_PASSWORD=$DB_PASSWORD_DEV
fi
if [ "$DUPLICATI__backup_name" == "prod" ]
then
        DB_PASSWORD=$DB_PASSWORD_PROD
fi

if [ "$DUPLICATI__EVENTNAME" == "BEFORE" ]
then
	if [ "$DUPLICATI__OPERATIONNAME" == "Backup" ]
	then
		echo "test"
		docker exec mariadb_$DUPLICATI__backup_name mysqldump --opt --no-autocommit --user root --password=$DB_PASSWORD twomes > /dump_$DUPLICATI__backup_name/db.dump
		echo "test2"
	fi

elif [ "$DUPLICATI__EVENTNAME" == "AFTER" ]
then

        if [ "$DUPLICATI__OPERATIONNAME" == "Restore" ]
        then
                docker exec -i mariadb_$DUPLICATI__backup_name mysql --user root --password=$DB_PASSWORD twomes < /dump_$DUPLICATI__backup_name/db.dump
        fi
fi

exit 0
