#!/bin/bash

#LOG_FILE="List_snapshot_to_delete.`date +%Y_%m_%d_%H%M%S`.log"

files_to_delete=(
    "snap_vol_older_than_date.txt"
    "volume_does_not_exists.txt"
    "snapshot_list_to_delete.txt"
    "volume_exists.txt"
)

for filename in "${files_to_delete[@]}";
do
        rm -rf "$filename"
done


aws ec2 describe-snapshots --owner-ids 531690557709 --query 'Snapshots[?StartTime<=`2024-01-01`].{VolumeId:VolumeId,SnapshotId:SnapshotId}' --output text | tee -a snap_vol_older_than_date.txt
for i in `awk '{print $2}' snap_vol_older_than_date.txt | sort -u `
do
        volume_ID_status=$(aws ec2 describe-volumes --volume-ids $i | grep -i state) 2>/dev/null
        if [[ $? -ne 0 ]]; then
                echo "$i" >> volume_does_not_exists.txt
                grep $i snap_vol_older_than_date.txt | awk '{print $1}' >> snapshot_list_to_delete.txt

        else
                echo "$i" >> volume_exists.txt
        fi


done 
