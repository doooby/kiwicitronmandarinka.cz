class Pages::Page

    attr_reader :file

    def initialize file
        @file = file
        @layout_file = 'pages'
        @locals = {}
    end

    def read_page_template
        File.read "src/pages/#{@file}.html.erb"
    end

    def read_layout_template
        File.read "src/layouts/#{@layout_file}.html.erb"
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

end