#!/usr/bin/env ruby

require_relative '../app'
app_bundle! :build, :serve
app_load! reload: true

set :port, 3000
set :public_folder, ROOT_PATH.join('docs')

get '/*' do
    page_name = params['splat'].first
    page_name = 'index' if page_name == ''
    path = Pages.get_page_path page_name

    if File.exist? path
        page = Pages::Page.new page_name
        content_type 'text/html'
        page.render
    else
        pass
    end
end

Sinatra::Application.run!
