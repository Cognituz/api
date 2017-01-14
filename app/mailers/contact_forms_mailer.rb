class ContactFormsMailer < ActionMailer::Base
  def notification(contact_form)
    @contact_form = contact_form
    mail to: '2112.oga@gmail.com'
  end
end
