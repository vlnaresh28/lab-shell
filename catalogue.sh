source common.sh
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}
status_check $?
yum install nodejs -y &>>${log_file}
status_check $?
useradd roboshop&>>${log_file}
status_check $?
mkdir /app &>>${log_file}
status_check $?
rm -rf /app/*&>>${log_file}
status_check $?
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip&>>${log_file}
status_check $?
cd /app&>>${log_file}
status_check $?
unzip /tmp/catalogue.zip&>>${log_file}
status_check $?
cd /app&>>${log_file}
status_check $?
npm install &>>${log_file}
status_check $?

cp configs/catalogue.service  /etc/systemd/system/catalogue.service
&>>${log_file}
status_check $?
systemctl daemon-reload&>>${log_file}
status_check $?
systemctl enable catalogue &>>${log_file}
status_check $?
systemctl start catalogue&>>${log_file}
status_check $?

cp configs/mongodb.repo  /etc/yum.repos.d/mongo.repo &>>${log_file}
status_check $?
yum install mongodb-org-shell -y &>>${log_file}
status_check $?
mongo --host mongodb.learndevopseasy.online </app/schema/catalogue.js &>>${log_file}
status_check $?