#!/usr/bin/env ruby

require_relative '../app'
app_bundle! :storage
app_load!

args = ARGV
command = case args.shift
when 'upload' then Storage::Cli::Upload
else raise 'unknown command'
end

command.call args