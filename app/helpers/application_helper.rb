module ApplicationHelper
  def port_open?(host, port)
    wait = 300/1000.0 #milliseconds, the .0 is required!!
    require 'timeout'
    require 'socket'
    isopen = false
    begin
      Timeout::timeout(wait) {
        TCPSocket.new host, port
        isopen = true
      }
    rescue Exception
      # could not connect to the server
    end
    return isopen
  end

  def render_md(content)
    renderer = Redcarpet::Render::HTML.new({
      filter_html: true,
      no_styles: true,
      safe_links_only: true,
      hard_wrap: true,
      link_attributes: {target: "_blank", rel: "nofollow"}
    })
    md = Redcarpet::Markdown.new(renderer, {
      no_intra_emphasis: true,
      tables: true,
      fenced_code_blocks: true,
      autolink: true,
      strikethrough: true,
      lax_spacing: true,
      disable_indented_code_blocks: false,
      space_after_headers: false,
      underline: true,
      highlight: true,
      footnotes: true
    })
    md.render(content)
  end

  def render_mini_md(content)
    renderer = Redcarpet::Render::HTML.new({
      filter_html: true,
      no_images: true,
      no_styles: true,
      safe_links_only: true,
      hard_wrap: false,
      link_attributes: {target: "_blank", rel: "nofollow"}
    })
    md = Redcarpet::Markdown.new(renderer, {
      no_intra_emphasis: true,
      tables: false,
      fenced_code_blocks: false,
      autolink: true,
      strikethrough: true,
      lax_spacing: false,
      disable_indented_code_blocks: true,
      space_after_headers: true,
      underline: true,
      highlight: true,
      footnotes: false
    })
    md.render(content)
  end
end