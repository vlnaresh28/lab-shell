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


print_head "Installaling Nginx "
yum install nginx -y &>>${log_file}
status_check $?
 

print_head  "Removing Old Content"
rm -rf /usr/share/nginx/html/*  &>>${log_file}
status_check $?
 

print_head "Downloading Frontend Content"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip  &>>${log_file}
status_check $?
 

print_head "Extracting Downloaded Frontend"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip &>>${log_file} 
status_check $?
 

print_head "Copying Nginx Config for RoboShop "
cp ${code_dir}/configs/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf  &>>${log_file}
status_check $?
 

print_head "Enabling nginx  "
systemctl enable nginx &>>${log_file}
status_check $?
 

print_head "reStarting nginx "
systemctl restart nginx  &>>${log_file}
status_check $?