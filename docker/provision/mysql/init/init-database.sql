# create databases
CREATE DATABASE IF NOT EXISTS `pepperlocal`;
CREATE DATABASE IF NOT EXISTS `housekeepinglocal`;

# create root user and grant rights
CREATE USER 'root'@'localhost' IDENTIFIED BY 'pass';
GRANT ALL ON *.* TO 'root'@'%';