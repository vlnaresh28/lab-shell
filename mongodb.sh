cp configs/mongodb.repo  /etc/yum.repos.d/mongodb
yum install mongodb-org -y 
systemctl enable mongod 
systemctl start mongod 
