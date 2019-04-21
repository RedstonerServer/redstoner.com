class SitemapsController < ApplicationController

  layout :false
  before_action :init_sitemap

  def index
    @forums = Forum.all
  end

  private

  def init_sitemap
    headers['Content-Type'] = 'application/xml'
  end

end
