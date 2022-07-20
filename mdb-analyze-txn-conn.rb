#!/usr/bin/env ruby

require 'json'
require 'date'
require 'optparse'
require 'set'

options = {}

OptionParser.new do |parser|
  parser.banner = "Usage: mdb-analyze-txn-conn.rb -f <LOGFILE> [-f <LOGFILE>]"

  parser.on("-f", "--file FILENAME", String, "Log file to analyse. Can be specified multiple times", "User must provide at least one file name") do |filename|
    if options.has_key?(:files)
      options[:files] << filename
    else
      options[:files] = Array(filename)
    end
  end
end.parse!

connection_ids = {}
client_metadata = Set.new()

options[:files].each do |filename|
  # First pass - extract the connections used by TXN
  File.readlines(filename).each do |log_entry|
    unless log_entry.empty?
      parsed_log_line = JSON.parse(log_entry)

      if parsed_log_line.dig("c") == "TXN"
        connect_id = parsed_log_line.dig("ctx")
        unless connection_ids.has_key?(connect_id)
          connection_ids[connect_id] = 0
        end
        connection_ids[connect_id] = connection_ids[connect_id] + 1
      end
    end
  end
  # Second pass - find the connection events used by the identified connections
  File.readlines(filename).each do |log_entry|
    unless log_entry.empty?
      parsed_log_line = JSON.parse(log_entry)

      if parsed_log_line.dig("c") == "NETWORK" and parsed_log_line.dig("msg") == "client metadata"
        if connection_ids.has_key?(parsed_log_line.dig("ctx"))
          client_metadata.add(log_entry)
        end
      end
    end
  end
end

# connection_ids.each_pair do |key, value|
#   puts("Connection %s is used %d times in TXN" % [ key, value ])
# end

client_metadata.each do |entry|
  puts(entry)
end
