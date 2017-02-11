#!/usr/bin/env bash

STORAGE_1_MOUNT_POINT="/media/storage-1"
STORAGE_2_MOUNT_POINT="/media/storage-2"
BACKUP_BOX_PATH="/home/pi/.backup-box"

echo "Installation of required packages"
sudo apt-get update && sudo apt-get install acl rsync exfat-fuse exfat-utils ntfs-3g -y

echo "Creating storage-1 directory: $STORAGE_1_MOUNT_POINT"
sudo mkdir $STORAGE_1_MOUNT_POINT
echo "Creating storage-2 directory: $STORAGE_2_MOUNT_POINT"
sudo mkdir $STORAGE_2_MOUNT_POINT

echo "Setting permissions for storage-1"
sudo chown -R pi:pi $STORAGE_1_MOUNT_POINT
sudo chmod -R 775 $STORAGE_1_MOUNT_POINT
sudo setfacl -Rdm g:pi:rw $STORAGE_1_MOUNT_POINT

echo "Copying script to: $BACKUP_BOX_PATH"
mkdir -p $BACKUP_BOX_PATH && cp backup.sh remove.sh $BACKUP_BOX_PATH/ && chmod +x $BACKUP_BOX_PATH/remove.sh

echo "Adding script to crontab"
(crontab -l | grep -v "$BACKUP_BOX_PATH/backup.sh") | crontab -
(crontab -l ; echo "@reboot sudo $BACKUP_BOX_PATH/backup.sh > $BACKUP_BOX_PATH/backup.log 2>&1") | crontab -

echo "To uninstall run command: ~/.backup-box/remove.sh"

echo "------------------------"
echo "All done! Please reboot."
echo "------------------------"
