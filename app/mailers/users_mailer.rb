class UsersMailer < ApplicationMailer
  def teacher_invite(user_id)
    @user = User.find(user_id)

    mail(to: @user.email, subject: "Invitación a Cognituz")
  end
end
