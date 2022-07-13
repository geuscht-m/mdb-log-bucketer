# mdb-log-bucketer

This script analyses one or more JSON format mongod log files, counts the occurance of a specific category (for example "TXN" or "NETWORK") and aggregates the number of occurences hourly. The main purpose is to be able to see if there is an uneven distribution of certain event categories over the course of a day or multiple days.

The script only works with the structured log format that was introduced in MongoDB 4.4 and currently has only been tested on Ruby 3.1.2 using MongoDB 5.0 log files.

The script takes the following parameters:

-t/--type <CATEGORY> with <CATEGORY> being one of the categories listed in the MongoDB documentation [here](https://www.mongodb.com/docs/manual/reference/log-messages/#components)
-f/--file <FILENAME> path/name of the log file to process. This parameter can be provided multiple times

