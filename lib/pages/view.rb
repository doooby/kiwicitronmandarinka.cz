require 'erubi/capture_block'

class Pages::View

  def initialize
    @buffer = nil
  end

  def self.render template, **variables
    view = new
    variables.each{|key, value| view.instance_variable_set "@#{key}", value }
    engine = Erubi::CaptureBlockEngine.new template, bufvar: '@buffer'
    view.instance_eval engine.src
  end

  def tag__page_header is_subpage: true
    <<-DOC
<header>
  <div class="container my-3">
    <div class="row">
      <div class="col">
        <h1 class="text-center">Pejskovi na Aotearoa 🇳🇿</h1>
        #{'<a href="/"><- zpět</a>' if is_subpage}
      </div>
    </div>
  </div>
</header>
      DOC
  end

  def tag__index_item date:, url:, title:, &block
    <<-DOC
<div>
  <h3>
    <a href="#{url}">#{title}</a>
  </h3>
  <h6 class="text-body-secondary">
    #{date}
  </h6>
  <div class="col-12">
    #{@buffer.capture &block}
  </div>
</div>
    DOC
  end

  def tag__article title, date, &block
      <<-DOC
<article class="container py-3 article">
  <header>
      <h2>#{title}</h2>
      <h6 class="text-body-secondary">#{date}</h6>
  </header>
  #{@buffer.capture &block}
</article>
      DOC
  end

  def tag__article__text_section className: nil, &block
      <<-DOC
<section class="article__text_section #{className}">
#{@buffer.capture &block}
</section>
      DOC
  end

  def tag__image_in_row path, text=nil
    th_url, og_path = Storage.asset_urls path
    <<-DOC
<div class="col-xm-6 col-md-4 col-xl-2 mb-4 d-flex justify-content-center">
  <div style="max-width: 300px;">
    <a href="#{og_path}">
      <img class="img-fluid" src="#{th_url}">
    </a>
    #{"<small>#{text}</small>" if text}
  </div>
</div>
    DOC
  end

end
