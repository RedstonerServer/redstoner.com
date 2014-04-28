class RegistrationPreview < ActionMailer::Preview
  @@user = User.new(id: 123, uuid: "aabbccddeeff11223344556677889900", ign: "fancy_user", name: "fancy_user", email_token: "abcdefg", email: "fancymail@example.com", created_at: Time.now, last_ip: "1.2.3.4")

  def register_mail_normal
    RedstonerMailer.register_mail(@@user, false)
  end

  def register_mail_idiot
    RedstonerMailer.register_mail(@@user, true)
  end

  def register_info_mail_normal
    RedstonerMailer.register_info_mail(@@user, false)
  end

  def register_info_mail_idiot
    RedstonerMailer.register_info_mail(@@user, true)
  end
end