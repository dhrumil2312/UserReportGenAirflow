#!/usr/bin/bash


echo "Creating backup of table user in hive"

file="user_$(date +%Y%m%d_%H%M%S)"

sqoop import --connect jdbc:mysql://localhost/exercise_1 --username root --password-file /user/cloudera/root_pwd.txt -m 4 --table user --target-dir /user/cloudera/sqoop-mysql/${file}/ --fields-terminated-by "," --hive-import --hive-overwrite --hive-table users

if [ $? -eq 0 ]
then
        echo "Sqoop import command ran successfully"
else
        echo "Error in creating Backup. Exiting.........." >&2
        exit 1
fi

echo "Backup Created"

