#!/usr/bin/bash

hive -e "drop table if exists  latest_activity_user;" 

hive -e "drop table if exists  total_activity_user;"  

hive -e "drop table if exists  pre_final;"  

hive -e "drop table if exists  user_files;"   

hive -e "drop table if exists  user_report;"


hive -e "create table latest_activity_user as select user_id , type , if(unix_timestamp() - timestamp < 172800,1,0) is_active from (select * from (select * , row_number() over (partition by user_id order by timestamp desc) as rn from activitylog )a  where rn = 1) b;"

if [ $? -eq 0 ]
then
        echo "Latest Activity User table created successfully"
else
        echo "Error in creating table.  Please check $LOG_HOME/users_report.log for error. Exiting.........." >&2
        exit 1
fi

hive -e "create table total_activity_user as select user_id , sum(total_insert) , sum(total_update) , sum(total_delete) from (select user_id , if(type ='INSERT' , cnt, 0) total_insert, if(type ='UPDATE' , cnt, 0) total_update, if(type ='DELETE' , cnt, 0) total_delete from (select user_id , type , count(1) cnt from activitylog group by user_id , type ) a)b group by user_id ;" 

if [ $? -eq 0 ]
then
        echo "Total acitivity User table created successfully"
else
        echo "Error in creating table.  Please check $LOG_HOME/users_report.log for error. Exiting.........." >&2
        exit 1
fi


hive -e "create table pre_final as select a.* ,b.type , b.is_active from total_activity_user a , latest_activity_user b where a.user_id = b.user_id; " 

if [ $? -eq 0 ]
then
        echo "Pre Final table created successfully"
else
        echo "Error in creating table.  Please check $LOG_HOME/users_report.log for error. Exiting.........." >&2
        exit 1
fi


hive -e "create table user_files as select user_id , count(1) cnt from user_upload_dump group by user_id ;"

if [ $? -eq 0 ]
then
        echo "User files table created successfully"
else
        echo "Error in creating table.  Please check $LOG_HOME/users_report.log for error. Exiting.........." >&2
        exit 1
fi


hive -e "create table user_report as select a.* , if(b.cnt = NULL, 0 ,b.cnt) upload_count from pre_final a left outer join user_files b on (a.user_id = b.user_id) ;"

if [ $? -eq 0 ]
then
        echo "User Report Generated Successfully......"
else
        echo "Error in creating report.  Please check $LOG_HOME/users_report.log for error. Exiting.........." >&2
        exit 1
fi

