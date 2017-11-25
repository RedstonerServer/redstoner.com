atom_feed do |feed|
  feed.title "Latest threads in " + @forum.name
  feed.updated Time.now

  @threads.limit(10).each do |thread|
    unless thread.sticky?
      feed.entry thread do |entry|
        entry.updated thread.updated_at
        entry.author do |a|
          a.name thread.author.name
          a.uri user_url(thread.author)
        end
        entry.url forumthread_url(thread)
        entry.title thread.title
        entry.content render_md(thread.content).html_safe, :type => 'html'
      end
    end
  end
end
