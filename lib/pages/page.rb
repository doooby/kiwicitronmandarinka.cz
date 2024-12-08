class Pages::Page

    attr_reader :file

    def initialize file
        @file = file
        @layout_file = 'pages'
        @locals = {}
    end

    def [] name
        @locals[name]
    end

    def []= name, value
        @locals[name] = value
    end

    def set_layout file
        @layout_file
    end

    def render
        body_content = Pages::View.render(
            File.read(Pages.get_page_path @file),
            page: self
        )
        Pages::View.render(
            File.read(Pages.get_layout_path @layout_file),
            page: self,
            body_content:
        )
    end

end