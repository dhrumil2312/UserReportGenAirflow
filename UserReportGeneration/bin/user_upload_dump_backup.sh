#!/usr/bin/bash

# /user/cloudera/exercise1/userlogs/ should exists before running this script if not run below commands

# hadoop fs -mkdir /app/
# hadoop fs -mkdir /app/data/
# hadoop fs -mkdir /app/data/user_upload/
# mkdir old_files/

for filename in `ls /home/cloudera/airflow/dags/UserReportGeneration/bin/*csv` ; do
hadoop fs -put $filename /app/data/user_upload/
if [ $? -eq 0 ]
then
        echo "$filename moved to hadoop"
else
        echo "Error in moving $filename to hadoop" >&2
        exit 1
fi

mv $filename /home/cloudera/airflow/dags/UserReportGeneration/old_files/

if [ $? -eq 0 ]
then
        echo "$filename moved to backup folder"
else
        echo "Error in moving $filename to backup folder" >&2
        exit 1
fi

done




hive -e "CREATE EXTERNAL TABLE IF NOT EXISTS user_upload_dump (user_id int, file_name STRING,     timestamp STRING) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE LOCATION '/app/data/user_upload/' TBLPROPERTIES ('skip.header.line.count'='1');" 

if [ $? -eq 0 ]
then
        echo "Hive command Ran successfully............."
else
        echo "Error in hive command......................." >&2
        exit 1
fi

