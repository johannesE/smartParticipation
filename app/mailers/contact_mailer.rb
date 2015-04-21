class ContactMailer < ActionMailer::Base
  default from: "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.contact_mailer.user_contacts_user.subject
  #
  def user_contacts_user(origin_user, message, target_user)
    @greeting = "Hi " + target_user.username
    @message = message
    subject = origin_user.username + " has contacted you on SmartParticipation"
    mail to: target_user.email, reply_to: origin_user.email, from: 'johannes.eifert@unifr.ch', subject: subject
  end
end
