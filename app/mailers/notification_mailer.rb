class NotificationMailer < ApplicationMailer
  default from: "runaclothes@gmail.com"

  def signup_email(user)
    @username = user.name
    mail to: user.email, subject: "ユーザー登録が完了しました!"
  end

  def desginersignup_email(user)
    @username = user.name
    mail to: user.email, subject: "デザイナー登録が完了しました!"
  end

  def post_email(user, post)
    @username = user.name
    @itemname = post.name
    mail to: user.email, subject: "アイテムが出品されました"
  end
end
