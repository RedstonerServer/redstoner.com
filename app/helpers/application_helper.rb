module ApplicationHelper

  def title(site_title)
    content_for(:site_title, site_title.to_s.html_safe) # html_safe because it's escaped again later (yield?)
    site_title
  end

  def site_headers(site_headers)
    content_for(:site_headers, site_headers.to_s.html_safe)
    site_headers
  end

  def ago(tm)
    if tm
      content_tag :time, title: tm.strftime("%e %b %Y, %H:%M %Z"), datetime: tm.to_datetime.rfc3339 do
        tm.strftime("%e %b %Y, %H:%M")
      end
    end
  end

  def render_md(content)
    renderer = Redcarpet::Render::HTML.new({
      filter_html: true,
      no_styles: true,
      safe_links_only: true,
      with_toc_data: true,
      hard_wrap: true,
      link_attributes: {rel: "nofollow"}
    })
    md = Redcarpet::Markdown.new(renderer, {
      tables: true,
      fenced_code_blocks: true,
      autolink: true,
      strikethrough: true,
      lax_spacing: true,
      disable_indented_code_blocks: false,
      space_after_headers: false,
      superscript: true,
      underline: true,
      highlight: true,
      footnotes: true
    })
    render_youtube(md.render(content))
  end

  def render_trusted_md(content)
    renderer = Redcarpet::Render::HTML.new({
      filter_html: false,
      no_styles: false,
      safe_links_only: false,
      with_toc_data: true,
      hard_wrap: true,
    })
    md = Redcarpet::Markdown.new(renderer, {
      tables: true,
      fenced_code_blocks: true,
      autolink: true,
      strikethrough: true,
      lax_spacing: true,
      disable_indented_code_blocks: false,
      space_after_headers: false,
      superscript: true,
      underline: true,
      highlight: true,
      footnotes: true
    })
    render_youtube(md.render(content))
  end

  # calculate the foreground color
  # either +dark+ or +light+, based on the +bgcolor+
  def fcolor(bgcolor = "#000", light = "#fff", dark = "#000")
    bg = bgcolor.gsub(/[^0-9a-f]/i, "")
    # convert 3 char to 6 char hex
    bg.gsub!(/./, '\&\&') if bg.length == 3
    sum = 0
    [0, 2, 4].each do |i|
      sum += bg[i..i+1].to_i(16)
    end
    return (sum/3 < 128) ? light : dark
  end

  private

  def render_youtube(content)
    # TODO: render only in text blocks, not in code/quotes/etc
    return content.gsub(
      /\[yt:([a-zA-Z0-9\-_]+)(:(\d+))?\]/,
      "<iframe class='youtube' allowfullscreen src='
        https://www.youtube-nocookie.com/embed/\\1?theme=light&vq=hd720&hd=1&iv_load_policy=3&showinfo=1&showsearch=0&rel=0&modestbranding&hd=1&autohide=1&html5=1&start=\\3'>
      </iframe>")
  end
end