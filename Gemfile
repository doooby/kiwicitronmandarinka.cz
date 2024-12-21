source 'https://rubygems.org'

gem 'zeitwerk'
gem 'colorize'
gem 'ostruct'
gem 'pathname'

group :build do
    gem 'fileutils'
    gem 'erubi'
end

group :serve do
    gem 'rackup'
    gem 'sinatra'
    gem 'puma'
    gem 'listen'
    gem 'digest'
end

group :storage do
    gem 'aws-sdk-s3'
    gem 'ox'
    gem 'concurrent-ruby'
end

group :build, :storage do
    gem 'csv'
end

group :build, :server, :storage do
    gem 'debug'
end
