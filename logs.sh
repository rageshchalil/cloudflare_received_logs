#!/bin/bash
# The script helps download Logs from cloudflare.
# Cloudlflare allows to download past seven day logs 
# https://api.cloudflare.com/#logs-received-logs-received
# Pre-requisites:
# auth_email: will be your Cloudflare email id.
# auth_key: go to your Cloudflare account profile -> API Token -> API keys -> Global API key
# zone_id: go to your Cloudflare account > overview > API > Zone ID.

auth_email=''
auth_key=''
zone_id=''
max_hour=24
month='11' #The month for which the logs should be generated
day_start='11' #The start day from when the logs needs to be generated
maxnumber_of_days=7 #Cloudflare can only provide previous 7 days logs
sitename='' #The websitename
output_folder="output/${sitename}"

# Create Output folders
mkdir -p "$output_folder"
Chmod -R 777 "$output_folder"

((end_counter=$day_start+6))
for ((i=$day_start;i<=$end_counter;i++)); do
    start_hour=0
    for end_hour in `seq 1 $max_hour`
    do
    	startdate=$(date -j -f "%Y:%m:%d %H:%M:%S" "2021:${month}:${i} ${start_hour}:00:00" +%s)
    	endtime=$(date -j -f "%Y:%m:%d %H:%M:%S" "2021:${month}:${i} ${start_hour}:59:00" +%s)
    	#echo $(date -r ${startdate}) --- $(date -r ${endtime})
    	filename="2021_${month}_${i}"
    	((start_hour=start_hour+1))

    	curl -o "$output_folder/${filename}.log" -X GET "https://api.cloudflare.com/client/v4/zones/${zone_id}/logs/received?start=${startdate}&end=${endtime}" \
    	-H "X-Auth-Email: ${auth_email}" \
    	-H "X-Auth-Key: ${auth_key}" \
    	-H "Content-Type: application/json"
    	
    done
done