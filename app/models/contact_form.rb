class ContactForm
  include ActiveModel::Model

  attr_accessor :sender_email, :subject, :body

  validates :sender_email, email: true
  validates :sender_email, presence: true

  def save
    return false unless valid?
    ContactFormsMailer.notification(self).deliver
    true
  end
end

class << ContactForm
  def create(attrs)
    new(attrs).tap(&:save)
  end
end
