require 'stringio'

class Pages::Page

    attr_accessor :layout, :page, :header_content, :body_content

    def initialize name
        @page = name
        @layout = 'pages'
    end

    def get_binding
        binding
    end

end