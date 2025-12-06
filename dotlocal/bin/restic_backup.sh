#!/bin/sh

passwordcommand="secret-tool lookup key restic-${HOSTNAME}"

# Mount backup target
answer=
if ! findmnt /mnt/backups > /dev/null 2>&1;then
  printf "/mnt/backups not mounted. Would you like to mount it? (y/n) " 
  read -r answer
  if [ "${answer}" != "${answer#[Yy]}" ] ;then 
    echo "Mounting /mnt/backups"
    sudo mount /mnt/backups || exit 1
  else
    exit 1
  fi
fi 

printf "Running restic backup"  

restic -r /mnt/backups --verbose backup "${HOME}" --exclude-file "${HOME}"/.restic/exclude.txt --password-command="${passwordcommand}"

printf "Running restic forget"

restic -r /mnt/backups  forget --keep-weekly 8 --keep-monthly 12 --keep-yearly 1 --password-command="${passwordcommand}"

answer=
printf "Would you like to prune? This may take a long time. (y/n) "
read -r answer
if [ "${answer}" != "${answer#[Yy]}" ] ;then 
  echo "Running restic prune"
  restic -r /mnt/backups prune --password-command="${passwordcommand}"
fi

answer=
printf "Would you like to unmount /mnt/backups? (y/n) "
read -r answer

if [ "${answer}" != "${answer#[Yy]}" ] ;then 
  echo "Unmounting /mnt/backups"
  sudo umount /mnt/backups
else
  echo "Leaving /mnt/backups mounted"
fi
