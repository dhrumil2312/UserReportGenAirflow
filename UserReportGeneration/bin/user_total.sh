#!/usr/bin/bash


#impala-shell -q "insert into user_total select current_timestamp() time_ran, c.present_cnt total_users, c.present_cnt - b.total_users users_added from  (select * from ( select * , row_number() over(order by time_ran desc) rn from user_total) a where rn = 1 ) b , (select count(1) present_cnt from users ) c ;" >> $LOG_HOME/user_total_report.log 2>&1


impala-shell -q "insert into user_total select current_timestamp() , cnt , if(total_users is null , cnt , cnt-total_users) from (select count(1) cnt from users ) a left join (select * from user_total b left join (select max(time_ran) max_time_ran from user_total) c on (b.time_ran = c.max_time_ran) )b on 1=1;"

exit $?
