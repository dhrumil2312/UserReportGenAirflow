from airflow import DAG
from airflow.operators.bash_operator import BashOperator
from datetime import datetime, timedelta

default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'email': ['airflow@example.com'],
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 2,
    'retry_delay': timedelta(minutes=1),
}


dag = DAG('ReportGeneration', default_args=default_args, start_date=datetime.now()-timedelta(minutes=1))



t1 = BashOperator(
    task_id='runLoadMySQLData',
    bash_command='/usr/local/bin/python2.7 /home/cloudera/airflow/dags/UserReportGeneration/bin/practical_exercise_data_generator.py --load_data ',
    dag=dag)

t2 = BashOperator(
    task_id='runCreateCSV',
    bash_command='/usr/local/bin/python2.7 /home/cloudera/airflow/dags/UserReportGeneration/bin/practical_exercise_data_generator.py --create_csv ',
    dag=dag)

t3 = BashOperator(
    task_id='runUserTableBackup',
    bash_command='source /home/cloudera/airflow/dags/UserReportGeneration/bin/users_backup.sh ',
    dag=dag)

t4 = BashOperator(
    task_id='runActivityLogTableBackup',
    bash_command='source /home/cloudera/airflow/dags/UserReportGeneration/bin/activity_log_backup.sh ',
    dag=dag)


t5 = BashOperator(
    task_id='runUserUploadDumpBackup',
    bash_command='source /home/cloudera/airflow/dags/UserReportGeneration/bin/user_upload_dump_backup.sh ',
    dag=dag)

t6 = BashOperator(
    task_id='runUserReport',
    bash_command='source /home/cloudera/airflow/dags/UserReportGeneration/bin/user_report.sh ',
    dag=dag)

t7 = BashOperator(
    task_id='runUserTotal',
    bash_command='source /home/cloudera/airflow/dags/UserReportGeneration/bin/user_total.sh ',
    dag=dag)

t1.set_downstream(t2)
t2.set_downstream([t5,t3,t4])
t3.set_downstream([t7,t6])
t4.set_downstream([t7,t6])
t5.set_downstream([t7,t6])
