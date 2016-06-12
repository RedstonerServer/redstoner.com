class RedstonerMailer < ActionMailer::Base

  add_template_helper(ApplicationHelper)
  default from: "info@redstoner.com"
  default reply_to: "redstonerserver+website@gmail.com"

  def register_mail(user, uses_mc_pass)
    @user = user
    @mcpw = uses_mc_pass
    mail(to: @user.email, subject: "Registration on Redstoner.com")
  end

  def register_info_mail(user, uses_mc_pass)
    @user = user
    @mcpw = uses_mc_pass
    mail(to: "redstonerserver@gmail.com", subject: "#{@user.name} registered on Redstoner")
  end

  def new_thread_mention_mail(user, thread)
    @user   = user
    @thread = thread
    mail(to: @user.email, subject: "#{thread.author.name} mentioned you in '#{thread.title}' on Redstoner")
  end

  def new_thread_reply_mail(user, reply)
    @user  = user
    @reply = reply
    mail(to: @user.email, subject: "#{reply.author.name} replied to '#{reply.thread.title}' on Redstoner")
  end

  def new_post_mention_mail(user, post)
    @user = user
    @post = post
    mail(to: @user.email, subject: "#{post.author.name} mentioned you in '#{post.title}' on Redstoner")
  end

  def new_post_comment_mail(user, comment)
    @user    = user
    @comment = comment
    mail(to: @user.email, subject: "#{comment.author.name} replied to '#{comment.blogpost.title}' on Redstoner")
  end

  def email_change_confirm_mail(user)
    @user = user
    mail(to: @user.email, subject: "Email change on Redstoner.com")
  end
end
