module Pages

    def self.get_page_path page
        ROOT_PATH.join('src/pages', "#{page}.html.erb")
    end

    def self.get_layout_path name
        ROOT_PATH.join('src/layouts', "#{name}.html.erb")
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

    def self.build_pages
        Pages.get_all_pages.each do |page|
            write_page page, page.render
        end
    end

    def self.write_page page, html
        dir = File.dirname page.file
        dir = ROOT_PATH.join 'docs', dir
        FileUtils.mkdir_p dir.to_s
        file = dir.join "#{page.file}.html"
        File.write file, html
    end

    def self.get_page_from_path path
        path = 'index' if path == ''
        file = Pages.get_page_path path
        Pages::Page.new path if File.exist? file
    end

end
