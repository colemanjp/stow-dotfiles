#!/bin/bash
passwordcommand="secret-tool lookup key restic-${HOSTNAME}"
excludefile="${HOME}/.restic/exclude.txt"
# Define backup targets
target1="/mnt/backups"
target2="/run/media/${USER}/restic-${HOSTNAME}"
target3="/run/media/${USER}/FFFF-F65E/restic-${HOSTNAME}"
# Choose backup target
printf "Select backup target:\n"
printf "  1) %s\n" "${target1}"
printf "  2) %s\n" "${target2}"
printf "  3) %s\n" "${target3}"
printf "Enter choice (1/2/3): "
read -r choice
case "${choice}" in
  1) backuptarget="${target1}" ;;
  2) backuptarget="${target2}" ;;
  3) backuptarget="${target3}" ;;
  *) printf "Invalid choice. Exiting.\n"; exit 1 ;;
esac
printf "Using backup target: %s\n" "${backuptarget}"
# Mount backup target if needed
# target2 and target3 are removable devices — assumed already mounted if they exist
if [[ "${backuptarget}" == "${target1}" ]]; then
  if ! findmnt "${backuptarget}" > /dev/null 2>&1; then
    printf "%s not mounted. Would you like to mount it? (y/n) " "${backuptarget}"
    read -r answer
    if [[ "${answer}" != "${answer#[Yy]}" ]]; then
      printf "Mounting %s\n" "${backuptarget}"
      sudo mount "${backuptarget}" || exit 1
    else
      exit 1
    fi
  fi
else
  if [[ ! -d "${backuptarget}" ]]; then
    printf "Target %s does not exist or is not mounted. Exiting.\n" "${backuptarget}"
    exit 1
  fi
fi
# Timestamps
# Store epoch timestamp for exclude file
excludefiletse=$(stat -c %Y "${excludefile}")
# Store last backup in json
lastbackupjs=$(restic -r "${backuptarget}" snapshots --json --latest 1 --password-command="${passwordcommand}")
# Store last backup timestamp from json
lastbackupts=$(echo "${lastbackupjs}" | jq -r '.[0].time')
# Store last backup timestamp in epoch format
lastbackuptse=$(date -d "${lastbackupts}" +%s)
printf "Running restic backup\n"
restic -r "${backuptarget}" --verbose backup "${HOME}" --exclude-file "${excludefile}" --password-command="${passwordcommand}"
printf "Running restic forget\n"
restic -r "${backuptarget}" forget --keep-weekly 8 --keep-monthly 12 --keep-yearly 1 --password-command="${passwordcommand}"
if [[ "${excludefiletse}" -gt "${lastbackuptse}" ]]; then
  printf "Exclude file timestamp is newer than last backup. Running exclude forget\n"
  restic -r "${backuptarget}" rewrite --forget --exclude-file "${excludefile}" --password-command="${passwordcommand}"
fi
printf "Would you like to prune? This may take a long time. (y/n) "
read -r answer
if [[ "${answer}" != "${answer#[Yy]}" ]]; then
  printf "Running restic prune\n"
  restic -r "${backuptarget}" prune --password-command="${passwordcommand}"
fi
# Offer to unmount — only makes sense for target1 (fstab-managed mount)
if [[ "${backuptarget}" == "${target1}" ]]; then
  printf "Would you like to unmount %s? (y/n) " "${backuptarget}"
  read -r answer
  if [[ "${answer}" != "${answer#[Yy]}" ]]; then
    printf "Unmounting %s\n" "${backuptarget}"
    sudo umount "${backuptarget}"
  else
    printf "Leaving %s mounted\n" "${backuptarget}"
  fi
fi
