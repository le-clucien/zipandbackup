#!/bin/bash

# FUNCTIONS

function cheatSheet() {
  # Define your own helper here. Example:
  echo "kaamelot.info"
  echo "/var/lib/docker/volumes/postgres_data # Database"
  echo "/var/lib/docker/volumes/minio_data # S3"
  exit 0
}

function banner() {
  echo "  _______                         _ ____             _                "
  echo " |___  (_)        /\             | |  _ \           | |               "
  echo "    / / _ _ __   /  \   _ __   __| | |_) | __ _  ___| | ___   _ _ __  "
  echo "   / / | | '_ \ / /\ \ | '_ \ / _\` |  _ < / _\` |/ __| |/ / | | | '_ \ "
  echo "  / /__| | |_) / ____ \| | | | (_| | |_) | (_| | (__|   <| |_| | |_) |"
  echo " /_____|_| .__/_/    \_\_| |_|\__,_|____/ \__,_|\___|_|\_\\__,_| .__/ "
  echo "         | |                                                   | |    "
  echo "         |_|                                                   |_|    "
  echo ""
}

function help() {
  banner
  echo "VPS and self hosting backups helper."
  echo "Quickly zip given directory from ssh host and download the file locally."
  echo ""
  echo "Usage"
  echo "zipandbackup.sh [flag]"
  echo "zipandbackup.sh [user@]host remote_dir local_dir backup_filename"
  echo "remote_dir and local_dir must be a directory, not a file. backup_filename can be written with or without the .zip extension."
  echo ""
  echo "Flags"
  echo "-s, --cheatSheet  : show known pathes defined in the cheatSheet() function of the script"
  echo "-h, --help        : show this help message"
  echo ""
  echo "Examples"
  echo "./zipandbackup.sh app.la-map.com /var/lib/docker/volumes/postgres_data ~/Documents lamap-postgres_data-240811"
  echo "./zipandbackup.sh clucien@columbo.app /var/lib/docker/volumes/ /root/backups/ columbo-volumes-240811.zip"
  echo ""
  echo "Requirements"
  echo "zip must be installed on the remote host."
  exit 0
}

function bad_format() {
  echo "ERROR: Bad format, 'zipandbackup.sh -h' to show help."
  echo ""
  echo "Usage:"
  echo "zipandbackup.sh [flag]"
  echo "zipandbackup.sh [user@]host remote_dir local_dir backup_filename"
  exit 0
}

# BAD FORMAT CHECK

if [ $# -ne 1 ] && [ $# -ne 4 ];
then
  bad_format
fi

# FLAGS

if [[ $1 == "-h" ]] || [[ $1 == "--help" ]];
then 
  help
elif [[ $1 == "-s" ]] || [[ $1 ==  "--cheatSheet" ]];
then
  cheatSheet
fi

# ARCHIVE THE DIRECTORY IN /tmp

ssh $1 "rm /tmp/backup.zip 2> /dev/null"
ssh $1 "cd $2 && zip -r /tmp/backup.zip ./"

output=$?

if [[ $output != "0" ]] && [[ $output != "18" ]];
then
  exit 1
fi

# CREATE THE OUTPUT PATH

output=$3

if [[ ${output:(-1)} != "/" ]];
then
  output+="/"
fi

output+=$4

if [[ ${output:(-4)} != ".zip" ]];
then
  output+=".zip"
fi

# DOWNLOAD THE ARCHIVE

scp $1:/tmp/backup.zip $output
