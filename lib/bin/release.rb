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
# sleep 3 # TODO restore

require_relative '../build_helper.rb'
BH = BuildHelper

current_branch = BH.exec_system 'git rev-parse --abbrev-ref HEAD'
unless current_branch == 'main'
    puts "Error: You must be on the main.".red
    exit 1
end

changes = BH.exec_system 'git diff-index HEAD --'
if changes && !changes.empty?
    puts "Error: Clean up main first.".red
    # exit 1 # TODO restore
end

BH.exec_system 'git show-ref --quiet refs/heads/release && git branch -d release'
BH.exec_system 'git fetch origin release'
BH.exec_system 'git checkout -b release origin/release'
BH.exec_system 'git merge main'
BH.exec_system 'git push origin release'
BH.exec_system 'git checkout main'
BH.exec_system 'git branch -d release'

puts
puts "done".green
puts
