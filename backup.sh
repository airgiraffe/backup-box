#!/usr/bin/env bash

# IMPORTANT:
# Run the install.sh script first
# to install the required packages and configure the system.

# Specify devices and their mount points
# Copy files from storage-1 to storage-2
STORAGE_1_DEV="sda1"
STORAGE_1_MOUNT_POINT="/media/storage-1"
STORAGE_2_DEV="sdb1"
STORAGE_2_MOUNT_POINT="/media/storage-2"
LOG_FILE="/home/pi/.backup-box/backup.log"

TIME="date --iso-8601=seconds"

# Set the ACT LED to heartbeat
sudo sh -c "echo heartbeat > /sys/class/leds/led0/trigger"

# Wait for a storage-1 device (e.g. a USB flash drive)
echo "$($TIME) Waiting for storage-1"
STORAGE=$(ls /dev/* | grep $STORAGE_1_DEV | cut -d"/" -f3)
while [ -z ${STORAGE} ]
  do
  sleep 1
  STORAGE=$(ls /dev/* | grep $STORAGE_1_DEV | cut -d"/" -f3)
done

# When the storage-1 device is detected, mount it
echo "$($TIME) Mount storage-1 in: $STORAGE_1_MOUNT_POINT"
mount /dev/$STORAGE_1_DEV $STORAGE_1_MOUNT_POINT

# Set the ACT LED to blink at 1000ms to indicate that the storage-1 device has been mounted
sudo sh -c "echo timer > /sys/class/leds/led0/trigger"
sudo sh -c "echo 1000 > /sys/class/leds/led0/delay_on"

# Wait for a storage-2 (e.g. card reader with SD card)
echo "$($TIME) Waiting for storage-2"
STORAGE_2_READER=$(ls /dev/* | grep $STORAGE_2_DEV | cut -d"/" -f3)
until [ ! -z $STORAGE_2_READER ]
  do
  sleep 1
  STORAGE_2_READER=$(ls /dev/sd* | grep $STORAGE_2_DEV | cut -d"/" -f3)
done

# If the storage-2 is detected, mount it
if [ ! -z $STORAGE_2_READER ]; then
  echo "$($TIME) Mount storage-2 in: $STORAGE_2_MOUNT_POINT"
  mount /dev/$STORAGE_2_DEV $STORAGE_2_MOUNT_POINT
  # Set the ACT LED to blink at 500ms to indicate that the storage-2 has been mounted
  sudo sh -c "echo 500 > /sys/class/leds/led0/delay_on"
  # Create new dir on storage-1 based on time and random suffix
  BACKUP_DIR="backup_`date +%Y-%m-%d_%H-%M-%S`_`head /dev/urandom | tr -dc A-Za-z0-9 | head -c10`"
  BACKUP_PATH=$STORAGE_1_MOUNT_POINT/"$BACKUP_DIR"
  echo "$($TIME) Creating directory in the storage-1: $BACKUP_PATH"
  mkdir -p $BACKUP_PATH
  # Set the ACT LED to blink at 250ms to indicate that the rsync starts
  sudo sh -c "echo 250 > /sys/class/leds/led0/delay_on"
  sudo sh -c "echo 250 > /sys/class/leds/led0/delay_off"
  # Perform backup using rsync
  echo "$($TIME) Starting copying files from $STORAGE_2_MOUNT_POINT/ to $BACKUP_PATH"
  rsync -avh $STORAGE_2_MOUNT_POINT/ $BACKUP_PATH
  # Copy the log file
  echo "$($TIME) Copying files completed"
  # Turn off the ACT LED to indicate that the backup is completed
  sudo sh -c "echo 0 > /sys/class/leds/led0/brightness"
  echo "$($TIME) Copying log file from $LOG_FILE to $BACKUP_PATH/backup.log and shutdown"
  cp $LOG_FILE $BACKUP_PATH/"backup.log"
  echo -n "" > $BACKUP_PATH/"backup.log"
fi

# Shutdown
sync
shutdown -h now
