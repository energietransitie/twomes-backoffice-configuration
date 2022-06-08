#!/bin/bash
if [ "$DUPLICATI__EVENTNAME" == "BEFORE" ]
then
	if [ "$DUPLICATI__OPERATIONNAME" == "Backup" ]
	then
		docker exec mariadb_dev mysqldump --opt --no-autocommit --user root --password=$DB_PASSWORD_DEV twomes > /dump_dev/db.dump 
	fi

elif [ "$DUPLICATI__EVENTNAME" == "AFTER" ]
then

        if [ "$DUPLICATI__OPERATIONNAME" == "Restore" ]
        then
                docker exec -i mariadb_dev mysql --user root --password=$DB_PASSWORD_DEV twomes < /dump_dev/db.dump
        fi
fi

exit 0
