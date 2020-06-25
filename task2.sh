#!/bin/bash

#Define Global Variables

JobName=$2
Branch=$1
Build_id=$3
Username=tarek
URL_Job="http://jenkins.iprice.com/job/${JobName}/job/${Branch}/${Build_id}/"
URL_Filter="api/json?pretty=true&tree=changeSet[items[comment,affectedPaths,commitId,msg,author[fullName]]]"
URL="${URL_Job}${URL_Filter}"

#Define Functions

get_changes() {

curl -g -u $Username "$URL" -o Commit_Changes.json 

}

#main

if [ "$#" -ne 3 ]; then
        echo "Script Usage: sh task2.sh Branch JobName Build_id"
        exit 1
fi

FILE="Commit_Changes.json"

if [ -f "$FILE" ]; then
    rm -r $FILE
fi

get_changes
cat Commit_Changes.json
