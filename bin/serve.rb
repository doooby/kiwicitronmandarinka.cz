#!/usr/bin/env ruby

require_relative '../lib/init'
my_bundle_require :build
require_relative '../lib/pages'

Pages.rebuild_pages

watch_dir = ROOT_PATH.join 'src'
listener = Listen.to watch_dir do
    Pages.rebuild_pages
end
listener.start

server = WEBrick::HTTPServer.new(
    Port: 3000,
    DocumentRoot: ROOT_PATH.join('docs')
)
trap 'INT' do server.shutdown end
server.start

