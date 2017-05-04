class ClassAppointment::Attachment < ApplicationRecord
  has_attached_file :content

  belongs_to :appointment,
    class_name: :ClassAppointment,
    inverse_of: :attachments

  validates_attachment_presence :content
  do_not_validate_attachment_file_type :content
end
