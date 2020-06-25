#!/bin/bash

#Define Global Variables
Branch="$1"
Job="$2"
Username=tarek

#Date 1 Jun 2020 converted to timestamp 
TimeStamp=1577808000

URL_Job="http://jenkins.iprice.com/job/${Job}/job/${Branch}/"
URL_Filter="api/json?tree=builds[fullDisplayName,id,number,timestamp,result]&pretty=true"
URL="${URL_Job}${URL_Filter}"

# Define Functions


Successful_Build() {

curl -g -u $Username "$URL" -o AllResult.json
jq '.builds[] | select(.result=="SUCCESS" and .timestamp>=env.TimeStamp)' AllResult.json > SuccessResult.json
jq .id SuccessResult.json | cut -d '"' -f 2 > id_file.txt

}

Generate_LogFile() {

FILE="Report_CICD.txt"

if [ -f "$FILE" ]; then
    rm -r $FILE
fi

while IFS= read -r line; do
    echo "${URL_Job}${line}" >> Report_CICD.txt
done < id_file.txt

}


#main

if [ "$#" -ne 2 ]; then
	echo "Script Usage: sh task1.sh Branch_name JobName"
	exit 1
fi


Successful_Build
Generate_LogFile
cat Report_CICD.txt
