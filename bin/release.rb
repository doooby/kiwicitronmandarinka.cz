#!/usr/bin/env ruby

require_relative '../app'
app_bundle!
app_load!

current_branch = app_sys_exec 'git rev-parse --abbrev-ref HEAD'
unless current_branch == 'main'
    puts "Error: You must be on the main.".red
    exit 1
end

changes = app_sys_exec 'git diff-index HEAD --'
if changes && !changes.empty?
    if ARGV[0] == 'commit'
        app_sys_exec 'git add --all'
        app_sys_exec 'git commit -m "next-release"'
    else
        puts "Error: Clean up / or commit main first.".red
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

app_sys_exec 'git branch -D release'
app_sys_exec 'git fetch origin release'
app_sys_exec 'git checkout -b release origin/release'

app_sys_exec 'git rm -r --cached -q docs/ && rm -rf docs/ && git commit -m "clenup"'
app_sys_exec 'git merge main'

app_sys_exec 'bin/build.rb'
app_sys_exec 'git add docs/ && git commit -m "build"'

app_sys_exec 'git checkout main'
app_sys_exec 'git push origin release'

puts
puts "done".green
puts
