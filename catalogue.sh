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


mkdir /app &>>${log_file}
status_check $?

print_head "Removing old content "
rm -rf /app/*&>>${log_file}
status_check $?

print_head "Downloading .zip files"
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip&>>${log_file}
status_check $?

cd /app&>>${log_file}
status_check $?

print_head "unziping the catalogue.zip "
unzip /tmp/catalogue.zip&>>${log_file}
status_check $?

print_head "moving to Application Directory "
cd /app&>>${log_file}
status_check $?

print_head "Installaling NPM "
npm install &>>${log_file}
status_check $?

print_head "Copy Catalogue service file "
cp configs/catalogue.service  /etc/systemd/system/catalogue.service &>>${log_file}
status_check $?

print_head "Reloading Demon tool "
systemctl daemon-reload&>>${log_file}
status_check $?

print_head "Enabling Catalogue service "
systemctl enable catalogue &>>${log_file}
status_check $?

print_head " Start Catalogue service "
systemctl start catalogue&>>${log_file}
status_check $?

print_head " copy the monogodb.repo file "
cp configs/mongodb.repo  /etc/yum.repos.d/mongo.repo &>>${log_file}
status_check $?

print_head "Installaling Mongodb Client "
yum install mongodb-org-shell -y &>>${log_file}
status_check $

print_head "loading Mongodb Schema "
mongo --host mongodb.learndevopseasy.online </app/schema/catalogue.js &>>${log_file}
status_check $?