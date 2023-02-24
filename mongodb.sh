code_dir=$(pwd)
log_file=/tmp/roboshop.log
rm -f ${log_file}


print_head() {
  echo -e "\e[36m$1\e[0m"
}

status_check() {
  if [ $1 -eq 0 ]; then
    echo SUCCESS
  else
    echo FAILURE
    echo "Read the log file ${log_file} for more information about error"
    exit 1
  fi
}


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
