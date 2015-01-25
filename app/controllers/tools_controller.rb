class ToolsController < ApplicationController

  def render_markdown
    if current_user
      render text: render_md(params[:text])
    else
      render text: "Error: You are not logged in!"
    end
  end

end