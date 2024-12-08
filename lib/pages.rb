module Pages

    def self.get_page_path page
        "src/pages/#{page}.html.erb"
    end

    def self.get_layout_path name
        "src/layouts/#{name}.html.erb"
    end

    def self.get_all_pages
        pages = []
        Dir.chdir 'src/pages' do
            Dir.glob '**/*.html.erb' do |relative_path|
                name = relative_path[0..-10]
                pages.push Page.new(name)
            end
        end
        pages
    end

    def self.build_public
        FileUtils.rm_rf 'public'
        FileUtils.cp_r 'src/public', 'public'
        Pages.get_all_pages.each do |page|
            html = page.render
            dir = "public/#{File.dirname page.file}"
            FileUtils.mkdir_p dir
            file = "public/#{page.file}.html"
            File.write file, html
        end
    end

    def self.get_page_from_url_path path
        path = 'index' if path == ''
        file = Pages.get_page_path path
        Pages::Page.new path if File.exist? file
    end

end
