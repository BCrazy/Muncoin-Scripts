#!/bin/bash

checkKey='"blocks"'
lastBlockId=`cat /tmp/currentBlockId`
TIMESTAMP=`date "+%Y-%m-%d %H:%M:%S"`
echo "$TIMESTAMP Last Block Id: $lastBlockId"

# Get Current Info from Daemon
OUTPUT=$( /root/mun/mun-cli getinfo 2>&1 )
#echo $OUTPUT

# Get MN Current Status.
MNOUTPUT=$( /root/mun/mun-cli mnsync status 2>&1 )
echo "$TIMESTAMP : $MNOUTPUT"

# Convert Data to Array for validation

while read -d, -r pair; do
  IFS=':' read -r key val <<<"$pair"
 # echo "$key = $val"
        if [ "$key" = "$checkKey" ]; then
#               echo "found: $key"
                blockId=$val
        fi
done <<<"$OUTPUT,"

#Info Data has a leading space, removing
blockId="$(echo -e "${blockId}" | tr -d '[:space:]')"


#Check my Block Vs Latest Block
if [ "$blockId" = "$lastBlockId" ]; then
        #if Behind, reindex.
                echo "$TIMESTAMP Stopping Daemon"
                /root/mun/mun-cli stop #stop the daemon
                #pause
                sleep 2
                echo "$TIMESTAMP Starting Reindex"
                /root/mun/mund -reindex #start Reindex
#               sleep 5
#               echo "$TIMESTAMP Tell MN to restart"
#               /root/mun/mun-cli masternode start-all #tell nodes to restart
                echo 1 > /tmp/restartStatus
fi

TIMESTAMP=`date "+%Y-%m-%d %H:%M:%S"`
echo "$TIMESTAMP Current Block Id: $blockId"

#save current BlockId into file
echo $blockId > /tmp/currentBlockId
