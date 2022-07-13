#!/usr/bin/env ruby

require 'json'
require 'date'
require 'optparse'

options = {}

OptionParser.new do |parser|
  parser.banner = "Usage: mdb-log-bucketer.rb -t <CATEGORY> -f <LOGFILE> [-f <LOGFILE>]"

  parser.on("-t", "--type CATEGORY", String, "Process and bucket operations of type CATEGORY", "Defaults to TXN if not specified") do |category|
    options[:type] = category
  end
  parser.on("-f", "--file FILENAME", String, "Log file to analyse. Can be specified multiple times", "User must provide at least one file name") do |filename|
    if options.has_key?(:files)
      options[:files] << filename
    else
      options[:files] = Array(filename)
    end
  end
end.parse!

type = "TXN"

if options.has_key?(:type)
  type = options[:type]
end

TimeBucket = Struct.new('TimeBucket', :year, :month, :day, :hour)

buckets = {}

options[:files].each do |file|
  File.readlines(file).each do |line|
    line = line.strip()
    unless line.empty?
      parsed_log_line = JSON.parse(line)
      timefield = parsed_log_line.dig 't'
      timestamp_str = timefield.dig '$date'
      unless timestamp_str.empty?
        timestamp = DateTime.parse(timestamp_str)
        ops_type = parsed_log_line.dig 'c'

        if ops_type == type
          bucket = TimeBucket.new(timestamp.year, timestamp.month, timestamp.day, timestamp.hour)

          if buckets.has_key?(bucket)
            buckets[bucket] = buckets[bucket] + 1
          else
            buckets[bucket] = 1
          end
        end
      end
    end
  end
end

buckets.each_pair do | key, value |
  puts "Time bucket %4d-%02d-%02dT%02d contained %7d logged operations of type %s\n" % [ key.year, key.month, key.day, key.hour, value, type ]
end
