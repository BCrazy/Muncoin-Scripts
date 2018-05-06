#!/bin/bash

checkKey='"IsSynced"'
lastRestart=`cat /tmp/restartStatus`
TIMESTAMP=`date "+%Y-%m-%d %H:%M:%S"`
echo "$TIMESTAMP Restart Status : $lastRestart"

# Get Current Info from Daemon
OUTPUT=$( /root/mun/mun-cli mnsync status 2>&1 )
#echo $OUTPUT

# Convert Data to Array for validation

while read -d, -r pair; do
  IFS=':' read -r key val <<<"$pair"
 # echo "$key = $val"
        if [ "$key" = "$checkKey" ]; then
#               echo "found: $key"
                syncStatus=$val
        fi
done <<<"$OUTPUT,"

#Info Data has a leading space, removing
syncStatus="$(echo -e "${syncStatus}" | tr -d '[:space:]')"


#Check my Block Vs Latest Block
if [ "$lastRestart" = "1" ]; then
        if [ $syncStatus = "true" ]; then
                echo "$TIMESTAMP Tell MN to restart"
                /root/mun/mun-cli masternode start-all #tell nodes to restart
        fi
fi

TIMESTAMP=`date "+%Y-%m-%d %H:%M:%S"`
#echo "$TIMESTAMP Current Block Id: $blockId"

#save current BlockId into file
echo $lastRestart > /tmp/restartStatus
