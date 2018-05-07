#!/bin/bash

export AWS_DEFAULT_REGION=us-east-1
 
LogGroupName=$1
LogStreamName=$2
Mess=$3
Mess=`echo $Mess | sed -e "s/'//g"`

searchLogStream=$(aws logs describe-log-streams --log-group-name "$LogGroupName" | jq '.logStreams[] | select(.logStreamName == "'$LogStreamName'")')

if [ -z "$searchLogStream" ];
then
  echo create log stream $LogStreamName
  aws logs create-log-stream --log-group-name="$LogGroupName" --log-stream-name "$LogStreamName"
fi

UploadSequenceToken=$(echo $searchLogStream | jq .uploadSequenceToken)
echo token=$UploadSequenceToken
 
TimeStamp=`date "+%s%N" --utc`
TimeStamp=`expr $TimeStamp / 1000000`

if [ "$UploadSequenceToken" != "" ];
then
  CMD="aws logs put-log-events --log-group-name "$LogGroupName" --log-stream-name "$LogStreamName" --log-events \"timestamp=$TimeStamp,message='$Mess'\" --sequence-token $UploadSequenceToken"
else
  CMD="aws logs put-log-events --log-group-name "$LogGroupName" --log-stream-name "$LogStreamName" --log-events \"timestamp=$TimeStamp,message='$Mess'\""
fi

sh -c "${CMD}"

