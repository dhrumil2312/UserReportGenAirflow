#!/usr/bin/bash


echo " Starting backup of USERS table"

#sh users_backup.sh > $LOG_HOME/users_backup.log 2>&1

if [ $? -eq 0 ]
then
	echo "User backup done."
	echo "Starting Activity Log table backup"
else
	echo "Error in creating User Backup. Please check $LOG_HOME/users_backup.log for errors.  Exiting.........." >&2
	exit 1
fi

#sh activity_log_backup.sh > $LOG_HOME/activity_log_backup.log 2>&1
echo ""

if [ $? -eq 0 ]
then
        echo "Activity Log Backup Done........"
        echo "Starting User Upload Dump backup.............."
else
        echo "Error in creating Activity Log Backup. Please check $LOG_HOME/activitylogs.log for errors.  Exiting.........." >&2
        exit 1
fi

sh user_upload_dump_backup.sh > $LOG_HOME/user_upload_dump.log 2>&1

if [ $? -eq 0 ]
then
        echo "User upload dump backup done."
        echo "Generating report for User Total........."
else
        echo "Error in creating User Upload Dump Backup. Please check $LOG_HOME/user_uploads_dump.log for errors.  Exiting.........." >&2
        exit 1
fi

sh user_total.sh > $LOG_HOME/users_total.log 2>&1

if [ $? -eq 0 ]
then
        echo "User Total Reprot Generated"
        echo "Generating User Report"
else
        echo "Error in generating User Total Report. Please check $LOG_HOME/user_total.log for errors.  Exiting.........." >&2
        exit 1
fi


sh user_report.sh > $LOG_HOME/users_report.log 2>&1

if [ $? -eq 0 ]
then
        echo "User Report Generated........."
else
        echo "Error in generating User Report. Please check $LOG_HOME/user_report.log for errors.  Exiting.........." >&2
        exit 1
fi

