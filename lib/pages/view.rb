require 'erubi/capture_block'

class Pages::View

    # attr_reader :buffer

    def initialize
      @buffer = nil
    end

    def self.render template, **variables
      view = new
      variables.each{|key, value| view.instance_variable_set "@#{key}", value }
      engine = Erubi::CaptureBlockEngine.new template, bufvar: '@buffer'
      view.instance_eval engine.src
    end

    def tag__page_header
      <<-DOC
<header>
  <div class="container my-3">
      <div class="row">
          <div class="col">
              <h1 class="text-center">Pejskovi na Aotearoa 🇳🇿</h1>
              <a href="/"><- zpět</a>
          </div>
      </div>
  </div>
</header>
      DOC
  end

  def tag__article title, date, &block
      <<-DOC
<article class="container py-3">
  <header>
      <h2>#{title}</h2>
      <h6>#{date}</h6>
  </header>
  #{@buffer.capture &block}
</article>
      DOC
  end

  def tag__article_text_section &block
      <<-DOC
<section class="article_text_section">
#{@buffer.capture &block}
</section>
      DOC
  end

  def tag__image_in_row url, text=nil
      <<-DOC
<div class="col-xm-6 col-md-4 col-xl-2 mb-4 d-flex justify-content-center">
  <div style="max-width: 300px;">
      <a href="#{url}">
          <img class="img-fluid" src="#{url}">
      </a>
      #{"<small>#{text}</small>" if text}
  </div>
</div>
      DOC
  end

end
