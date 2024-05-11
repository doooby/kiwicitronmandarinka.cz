class Pages::Page

    attr_accessor :layout, :page, :body_content

    def initialize name
        @page = name
        @layout = 'pages'
    end

    def get_binding
        binding
    end

end