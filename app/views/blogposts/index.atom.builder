atom_feed do |feed|
  feed.title "Redstoner News"
  feed.updated Time.now

  @posts.each do |post|
    feed.entry post do |entry|
      entry.updated post.updated_at
      entry.author do |a|
        a.name post.author.name
        a.uri user_url(post.author)
      end
      entry.url blogpost_url(post)
      entry.title post.title
      entry.content render_md(post.content).html_safe, :type => 'html'
    end
  end
end