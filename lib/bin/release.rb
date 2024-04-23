#!/usr/bin/env ruby

require 'colorize'

puts
puts "kiwicitronmandarinka.cz".green
puts [
    "!!!".red,
    "Release in 3 sec".yellow,
    "!!!".red,
].join(" ")
puts
# sleep 3

require_relative '../build_helper.rb'
BH = BuildHelper

current_branch = BH.exec_system 'git rev-parse --abbrev-ref HEAD'
unless current_branch == 'main'
    puts "Error: You must be on the main.".red
    exit 1
end

changes = BH.exec_system 'git diff-index HEAD --'
if changes
    puts "Error: Clean up main first.".red
    exit 1
end

require 'byebug'
#byebug

puts
puts "done".green
puts
