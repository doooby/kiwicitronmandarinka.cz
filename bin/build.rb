#!/usr/bin/env ruby

require_relative '../app'
app_bundle! :build
app_load!

puts "... building pages"
Pages.build_public
puts "done".green
