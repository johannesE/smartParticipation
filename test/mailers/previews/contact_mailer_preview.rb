# Preview all emails at http://localhost:3000/rails/mailers/contact_mailer
class ContactMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/contact_mailer/user_contacts_user
  def user_contacts_user
    ContactMailer.user_contacts_user
  end

end
