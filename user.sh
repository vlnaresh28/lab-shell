source common.sh

print_head "Configure Nodejs repo "
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}
status_check $?

print_head "Installaling Nodejs "
yum install nodejs -y &>>${log_file}
status_check $?




print_head "Create Roboshop User"
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
curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip &>>${log_file}
status_check $?


cd /app &>>${log_file}


print_head "unziping the user.zip "
unzip /tmp/user.zip &>>${log_file}
status_check $?

print_head "moving to Application Directory "
cd /app &>>${log_file}
status_check $?

print_head "Installaling NPM "
npm install &>>${log_file}
status_check $?

print_head "Copy user service file "
cp ${code_dir}/configs/user.service  /etc/systemd/system/user.service &>>${log_file}
status_check $?

print_head "Reloading Demon tool "
systemctl daemon-reload &>>${log_file}
status_check $?

print_head "Enabling user service "
systemctl enable user &>>${log_file}
status_check $?

print_head " Start user service "
systemctl start user &>>${log_file}
status_check $?

print_head " copy the monogodb.repo file "
cp ${code_dir}/configs/mongodb.repo  /etc/yum.repos.d/mongo.repo &>>${log_file}
status_check $?

print_head "Installaling Mongodb Client "
yum install mongodb-org-shell -y &>>${log_file}
status_check $?

print_head "loading Mongodb Schema "
mongo --host mongodb.learndevopseasy.online </app/schema/user.js &>>${log_file}
status_check $?