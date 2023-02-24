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



schema_setup () {

if [ "${schema_type}" == "mongo" ] ; then

  print_head " copy the monogodb.repo file "
  cp ${code_dir}/configs/mongodb.repo  /etc/yum.repos.d/mongo.repo &>>${log_file}
  status_check $?

  print_head "Installaling Mongodb Client "
  yum install mongodb-org-shell -y &>>${log_file}
  status_check $?

  print_head "loading Mongodb Schema "
  mongo --host mongodb.learndevopseasy.online </app/schema/${component}.js &>>${log_file}
  status_check $?

fi

}


nodejs (){
  
print_head "Configure Nodejs repo "
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}
status_check $?

print_head "Installaling Nodejs "
yum install nodejs -y &>>${log_file}
status_check $?

print_head "Create Roboshop user"
  id roboshop  &>>${log_file}
  if [ $? -ne 0 ]; then
    useradd roboshop &>>${log_file}
  fi
  status_check $? 
  
print_head "Create Application Directory"
  if [ ! -d /app ]; then
    mkdir /app &>>${log_file}
  fi
  status_check $?


print_head "Removing old content "
rm -rf /app/* &>>${log_file}
status_check $?

print_head "Downloading .zip files"
curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log_file}
status_check $?

cd /app &>>${log_file}

print_head "unziping the ${component}.zip "
unzip /tmp/${component}.zip &>>${log_file}
status_check $?

print_head "moving to Application Directory "
cd /app &>>${log_file}
status_check $?

print_head "Installaling NPM "
npm install &>>${log_file}
status_check $?

print_head "Copy ${component} service file "
cp ${code_dir}/configs/${component}.service  /etc/systemd/system/${component}.service &>>${log_file}
status_check $?

print_head "Reloading Demon tool "
systemctl daemon-reload &>>${log_file}
status_check $?

print_head "Enabling ${component} service "
systemctl enable ${component} &>>${log_file}
status_check $?

print_head " Start ${component} service "
systemctl start ${component} &>>${log_file}
status_check $?

schema_setup

}