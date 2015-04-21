require 'test_helper'

class ContactMailerTest < ActionMailer::TestCase
  test "user_contacts_user" do
    mail = ContactMailer.user_contacts_user
    assert_equal "User contacts user", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
