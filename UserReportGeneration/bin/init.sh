
if [ `ps -fe | grep -i metastore | awk '{print $1}' | grep -i hive` = 'hive' ]
then
	echo "Sqoop Metastore service running"
else
	nohup sqoop metastore &
fi

hive -e "create table  user_total ( time_ran timestamp, total_users bigint,user_added bigint);"

if [ $? -eq 0 ]
then
        echo "USER Total table created..."
else
        echo "Error in creating user Total. Exiting.........." >&2
        exit 1
fi


export LOG_HOME=/root/Exercise1/UserReportGeneration/logs


hadoop fs -mkdir /app/
hadoop fs -mkdir /app/data/
hadoop fs -mkdir /app/data/user_upload/

hadoop fs -chmod 755 /app/

mkdir ../old_files/


sqoop job --meta-connect jdbc:hsqldb:hsql://localhost:16000/sqoop --create activitylog.logs -- import --connect jdbc:mysql://localhost/exercise_1 --username root --password-file /user/cloudera/root_pwd.txt --table activitylog --split-by id --hive-import --hive-table activitylog --incremental append --check-column id --last-value 0

if [ $? -eq 0 ]
then
        echo "Job created successfully"
else
        echo "Error in creating job. Exiting.........." >&2
        exit 1
fi

