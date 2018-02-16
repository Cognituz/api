class ContactFormsMailer < ActionMailer::Base
  def notification(contact_form)
    @contact_form = contact_form
    mail to: 'info@cognituz.com'
  end
end
