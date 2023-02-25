
source common.sh

print_head " disable mysql  "
dnf module disable mysql -y  &>>${log_file}
status_check $?


print_head " Installing Mysql  "
yum install mysql-community-server -y &>>${log_file} 
status_check $?


print_head " Enable Mysql  "
systemctl enable mysqld &>>${log_file}
status_check $?

print_head " Start Mysql  "
systemctl start mysqld  &>>${log_file}
status_check $?

print_head " Secure Install  Mysql  "
mysql_secure_installation --set-root-pass RoboShop@1 &>>${log_file}
status_check $?

print_head " Installing Mysql  "
mysql -uroot -pRoboShop@1 &>>${log_file}
status_check $?