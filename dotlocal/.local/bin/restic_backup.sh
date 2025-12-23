#!/bin/bash

passwordcommand="secret-tool lookup key restic-${HOSTNAME}"
excludefile="${HOME}/.restic/exclude.txt"

# Mount backup target
if ! findmnt /mnt/backups > /dev/null 2>&1;then
  printf "/mnt/backups not mounted. Would you like to mount it? (y/n) " 
  read -r answer
  if [[ "${answer}" != "${answer#[Yy]}" ]] ;then 
    printf "Mounting /mnt/backups\n"
    sudo mount /mnt/backups || exit 1
  else
    exit 1
  fi
fi 

# Timestamps
# Store epoch timestamp for exclude file
excludefiletse=$(stat -c %Y "${excludefile}")
# Store last backup in json
lastbackupjs=$(restic -r /mnt/backups snapshots --json --latest 1 --password-command="${passwordcommand}")
# Store last backup timestamp from json
lastbackupts=$(echo "${lastbackupjs}" | jq -r '.[0].time')
# Store last backuptimestamp in epoch format
lastbackuptse=$(date -d "${lastbackupts}" +%s)

printf "Running restic backup"

restic -r /mnt/backups --verbose backup "${HOME}" --exclude-file "${excludefile}" --password-command="${passwordcommand}"

printf "Running restic forget"

restic -r /mnt/backups  forget --keep-weekly 8 --keep-monthly 12 --keep-yearly 1 --password-command="${passwordcommand}"

if [[ "${excludefiletse}" -gt "${lastbackuptse}" ]]; then
  printf "Exclude file timestamp is newer than last backup. Running exclude forget\n"
  restic -r /mnt/backups rewrite --forget --exclude-file "${excludefile}" --password-command="${passwordcommand}"
fi

printf "Would you like to prune? This may take a long time. (y/n) "
read -r answer
if [[ "${answer}" != "${answer#[Yy]}" ]] ;then 
  printf "Running restic prune\n"
  restic -r /mnt/backups prune --password-command="${passwordcommand}"
fi

printf "Would you like to unmount /mnt/backups? (y/n) "
read -r answer

if [[ "${answer}" != "${answer#[Yy]}" ]] ;then 
  printf "Unmounting /mnt/backups\n"
  sudo umount /mnt/backups
else
  printf "Leaving /mnt/backups mounted\n"
fi
