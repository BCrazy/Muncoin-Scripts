# Muncoin Scripts

Note: My Files are in /root/mun/ the path you use, below should be the same as where ever your files are. 

So I set mine up as root, and gave the system full rights to the files by running

chmod 777 blockMonitor.sh 
chmod 777 mnRestart.sh


Crontab Settings: 

# Run Every 20 mins, check what block i'm on, if I get stuck, trigger a reindex
*/20 * * * * /root/mun/blockMonitor.sh >> /var/log/blockMonitor.log 2>&1

# Master node Restart Process
*/5 * * * * /root/mun/mnRestart.sh >> /var/log/mnRestart.log 2>&1

