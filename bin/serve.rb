#!/usr/bin/env ruby

require_relative '../app'
app_bundle! :build, :serve
app_load! reload: true

set :port, 3000
set :public_folder, 'src/public'

get '/*' do
    page = Pages::get_page_from_url_path params['splat'].first
    if page
        content_type 'text/html'
        page.render
    else
        pass
    end
end

Sinatra::Application.run!
