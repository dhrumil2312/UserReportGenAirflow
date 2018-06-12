#!/usr/bin/bash


sqoop job --meta-connect jdbc:hsqldb:hsql://localhost:16000/sqoop --exec activitylog.logs

if [ $? -eq 0 ]
then
        echo "ActivityLog job Ran Successfully............"
else
        echo "Error in creating Backup. Exiting.........." >&2
        exit 1
fi

