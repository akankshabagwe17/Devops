#!/bin/bash

echo "This script deletes all the snapshots present in "snapshot_list_to_delete.txt".
Make sure the list is verified before proceeding."

# Prompt the user for confirmation
read -p "Are you sure you want to delete the snapshots present in "snapshot_list_to_delete.txt" ? (y/n): " answer

# Check the user's response
if [[ "$answer" =~ ^[yY]$ ]]; then
    # Delete EBS snapshot
    for snapshot_ID in `cat sample.txt`
    do
            aws ec2 delete-snapshot --snapshot-id $snapshot_ID
    done
else
    echo "Snapshot deletion canceled."
fi
