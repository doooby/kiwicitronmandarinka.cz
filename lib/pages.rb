module Pages

    def self.read_pages
        pages = []
        Dir.chdir 'src/pages' do
            Dir.glob '**/*.html.erb' do |relative_path|
                name = relative_path[0..-10]
                pages.push Page.new(name)
            end
        end
        pages
    end

    def self.rebuild_pages
        FileUtils.rm 'docs/index.html' if File.exist? 'docs.index.html'
        FileUtils.rm_r 'docs/pages' if Dir.exist? 'docs/pages'
        Pages.read_pages.each do |page|
            page.body_content = build_page_body page
            html = build_whole_page page
            write_page page, html
        end
    end

    def self.build_page_body page
        source = File.read "src/pages/#{page.page}.html.erb"
        erb = ERB.new source
        erb.result page.get_binding
    end

    def self.build_whole_page page
        layout_source = File.read "src/layouts/#{page.layout}.html.erb"
        erb = ERB.new layout_source
        erb.result page.get_binding
    end

    def self.write_page page, html
        if page.page == 'index'
            File.write 'docs/index.html', html
        else
            dir = File.dirname page.page
            FileUtils.mkdir_p "docs/pages/#{dir}"
            File.write "docs/pages/#{page.page}.html", html
        end
    end

end

require_relative 'pages/page'
