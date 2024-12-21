#!/usr/bin/env ruby

require_relative '../app'
app_bundle! :build, :serve, :storage
app_load! reload: true

set :port, 3000
set :public_folder, 'src/public'

get '/storage/*' do
    path = "storage/#{params['splat'].first}"
    next 404 unless File.exist? path

    etag Digest::SHA256.hexdigest(File.read path)
    cache_control :public, max_age: 600, must_revalidate: true

    mime = Storage::File.identify_mime path, File.extname(path)
    if params['th'] == '1'
        Storage::File.generate_thumb mime, path do |th_file|
            send_file th_file.path, type: 'image/png';
        end
    else
        send_file path, type: mime
    end
end

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
