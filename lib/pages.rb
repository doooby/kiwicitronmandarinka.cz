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
            page[:body_content] = Pages::View.render(
                page.read_page_template,
                page:
            )
            html = Pages::View.render(
                page.read_layout_template,
                page:
            )
            write_page page, html
        end
    end

    def self.write_page page, html
        if page.file == 'index'
            File.write 'docs/index.html', html
        else
            dir = File.dirname page.file
            FileUtils.mkdir_p "docs/pages/#{dir}"
            File.write "docs/pages/#{page.file}.html", html
        end
    end

end

require_relative 'pages/page'
