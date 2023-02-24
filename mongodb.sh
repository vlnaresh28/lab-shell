source common.sh

print_head "Setup Mongodb repository "
cp ${code_dir}/configs/mongodb.repo  /etc/yum.repos.d/mongo.repo &>>${log_file}
status_check $?
  
print_head "Installaling MongoDB "
yum install mongodb-org -y  &>>${log_file}
status_check $?




print_head "enable Mongodb "
systemctl enable mongod &>>${log_file}
status_check $?
 
print_head " Start Mongodb "
systemctl start mongod  &>>${log_file}
status_check $? 
