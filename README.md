# mdb-log-bucketer

This script analyses one or more JSON format mongod log files, counts the occurance of a specific category (for example "TXN" or "NETWORK") and aggregates the number of occurences hourly. The main purpose is to be able to see if there is an uneven distribution of certain event categories over the course of a day or multiple days.

The script only works with the structured log format that was introduced in MongoDB 4.4 and currently has only been tested on Ruby 3.1.2 using MongoDB 5.0 log files.

The script takes the following parameters:

Parameter | Description
----------|-------------
-t/--type <CATEGORY> | with <CATEGORY> being one of the categories listed in the MongoDB documentation [here](https://www.mongodb.com/docs/manual/reference/log-messages/#components). Defaults to 'TXN' if not specified
-f/--file <FILENAME> | path/name of the log file to process. This parameter can be provided multiple times. User must provide at least one file to process

# mdb-analyze-txn-conn

Identifies all connection ids that are being used by by transactions and outputs the associated client metadata log entries. This can be used to identify which clients and client applications are executing transactions.

Parameter | Description
----------|-------------
-f/--file <FILENAME> | path/name of the log file to process. This parameter can be provided multiple times. User must provide at least one file to process

# Prerequisites

All scripts are written in Ruby and have so far only been tested with Ruby 3.12 and with MongoDB 5.0 log files. They only use standard packages, so it should not be necessary to install any additional packages in order to run these scripts.
