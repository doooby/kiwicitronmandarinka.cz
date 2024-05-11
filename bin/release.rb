#!/usr/bin/env ruby

require_relative '../lib/init'
my_bundle_require

current_branch = my_exec_system 'git rev-parse --abbrev-ref HEAD'
unless current_branch == 'main'
    puts "Error: You must be on the main.".red
    exit 1
end

changes = my_exec_system 'git diff-index HEAD --'
if changes && !changes.empty?
    if ARGV[0] == 'commit'
        my_exec_system 'git add --all'
        my_exec_system 'git commit -m "next-release"'
    else
        puts "Error: Clean up main first.".red
        puts "you can auto-commit by `bin/release commit`"
        exit 1
    end
end

puts
puts "kiwicitronmandarinka.cz".green
puts [
    "!!!".red,
    "Release in 3 sec".yellow,
    "!!!".red,
].join(" ")
puts
sleep 3

my_exec_system 'git show-ref --quiet refs/heads/release && git branch -d release'
my_exec_system 'git fetch origin release'
my_exec_system 'git checkout -b release origin/release'
my_exec_system 'git merge main'
my_exec_system 'git push origin release'
my_exec_system 'git checkout main'
my_exec_system 'git branch -d release'
my_exec_system 'git push origin main'

puts
puts "done".green
puts
