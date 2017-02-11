#!/usr/bin/env bash

STORAGE_1_MOUNT_POINT="/media/storage-1"
STORAGE_2_MOUNT_POINT="/media/storage-2"
BACKUP_BOX_PATH="/home/pi/.backup-box"

echo "Unmounting storage-1 from: $STORAGE_1_MOUNT_POINT"
sudo umount $STORAGE_1_MOUNT_POINT
echo "Unmounting storage-2 from: $STORAGE_2_MOUNT_POINT"
sudo umount $STORAGE_2_MOUNT_POINT

echo "Removing storage-1 directory: $STORAGE_1_MOUNT_POINT"
sudo rm -rf $STORAGE_1_MOUNT_POINT
echo "Removing storage-2 directory: $STORAGE_2_MOUNT_POINT"
sudo rm -rf $STORAGE_2_MOUNT_POINT
echo "Removing script directory: $BACKUP_BOX_PATH"
sudo rm -rf $BACKUP_BOX_PATH

echo "Removing script from crontab"
(crontab -l | grep -v "$BACKUP_BOX_PATH/backup.sh") | crontab -

echo "------------------------"
echo "All done! Please reboot."
echo "------------------------"
