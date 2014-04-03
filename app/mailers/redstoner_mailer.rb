class RedstonerMailer < ActionMailer::Base

  default from: "info@redstoner.com"
  default reply_to: "redstonerserver+website@gmail.com"

  def  register_mail(user, uses_mc_pass)
    @user = user
    @mcpw = uses_mc_pass
    mail(to: @user.email, subject: "Registration on Redstoner.com", from: "info@redstoner.com", reply_to: "redstonerserver+website@gmail.com")
  end

  def  register_info_mail(user, uses_mc_pass)
    @user = user
    @mcpw = uses_mc_pass
    mail(to: "redstonerserver@gmail.com", subject: "#{@user.name} registered on Redstoner.com", from: "info@redstoner.com", reply_to: "redstonerserver+website@gmail.com")
  end
end