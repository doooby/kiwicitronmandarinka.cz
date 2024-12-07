#!/usr/bin/env ruby

require_relative '../app'
app_bundle! :build
lib_loader = app_load! reloading: true

Pages.rebuild_pages

Listen
    .to(ROOT_PATH.join 'lib'){
        lib_loader.reload
        Pages.rebuild_pages
    }
    .start

Listen
    .to(ROOT_PATH.join 'src'){ Pages.rebuild_pages }
    .start

server = WEBrick::HTTPServer.new(
    Port: 3000,
    DocumentRoot: ROOT_PATH.join('docs')
)
trap('INT'){ server.shutdown }
server.start

