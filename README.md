# AWS CloudWatchLogs put-log utility

* Use for the test of CloudWatchAlerm.
* If there is no LogStream, it creates it. If log already exists in LogStream, get token and put-log it.

### Requirement

* aws-cli
* jq

### Usage

##### Usage #####


create log group

```
./put-log.sh LogGroupName LogStreamName Message
```

ex)

```
./put-log.sh /aws/batch/job 20180507-5 "FATAL test error"
```

### License

MIT
