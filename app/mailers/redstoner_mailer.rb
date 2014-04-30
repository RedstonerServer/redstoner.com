class RedstonerMailer < ActionMailer::Base

  add_template_helper(ApplicationHelper)
  default from: "info@redstoner.com"
  default reply_to: "redstonerserver+website@gmail.com"

  def register_mail(user, uses_mc_pass)
    @user = user
    @mcpw = uses_mc_pass
    mail(to: @user.email, subject: "Registration on Redstoner.com", from: "info@redstoner.com", reply_to: "redstonerserver+website@gmail.com")
  end

  def register_info_mail(user, uses_mc_pass)
    @user = user
    @mcpw = uses_mc_pass
    mail(to: "redstonerserver@gmail.com", subject: "#{@user.name} registered on Redstoner.com", from: "info@redstoner.com", reply_to: "redstonerserver+website@gmail.com")
  end

  def thread_reply_mail(user, reply)
    @user  = user
    @reply = reply
    mail(to: @user.email, subject: "#{reply.author.name} replied to '#{reply.thread.title}' on Redstoner", from: "info@redstoner", reply_to: "redstonerserver+website@gmail")
  end
end