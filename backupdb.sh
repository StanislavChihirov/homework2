#!/bin/bash

#Const
DB_NAME=moodle
DB_USER=prostouser
datetime=`date +%d.%m.%Y_%H:%M`
delimiter="_"
dirtobackup='/var/backup_db'
BIRed='\033[1;91m'
LGREEN='\033[1;32m'
NC='\033[0m' # No Color

#Generating file name to backup db
filename=$DB_NAME$delimiter$datetime".sql"

# Check which user run script
if [[ $EUID -ne 0 ]]; then
   echo -e "${BIRed}ERROR! This script must be run as root!${NC}" 
   exit 1
fi

#Check service status
MYSQL_START='sudo service mysql start'
MYSQL='mysql'
PGREP='/usr/bin/pgrep'
$PGREP $MYSQL
if [ $? -ne 0 ]; then
	echo -e "${BIRed}ERROR! The service MySQL dont RUN!${NC}"
$MYSQL_START
	echo -e "${LGREEN}The Service MySQL is STARTED!${NC}"
else
	echo -e "${LGREEN}All is good, service running :-)${NC}"
fi

#Create backup db
mysqldump --no-tablespaces -u $DB_USER $DB_NAME > $dirtobackup/$filename
#touch /home/chsp/scripts/$filename
	echo -e "${LGREEN}OK! Backup SQL made SUCCESSFULLY!${NC}"
