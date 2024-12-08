#!/usr/bin/env ruby

require_relative '../app'
app_bundle! :build
app_load!

puts "... building pages"

FileUtils.rm_rf 'docs'
FileUtils.cp_r 'src/public', 'docs'
Pages.get_all_pages.each do |page|
  html = page.render
  dir = "docs/#{File.dirname page.file}"
  FileUtils.mkdir_p dir
  file = "docs/#{page.file}.html"
  File.write file, html
end

puts "done".green
