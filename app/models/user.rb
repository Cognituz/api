class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :taught_subjects,
    class_name: :TaughtSubject,
    inverse_of: :user

  has_attached_file :avatar
  validates_attachment_content_type :avatar,
    content_type: %w[
      image/jpg
      image/jpeg
      image/png
      image/gif
    ]

  def name=(str)
    match = str.match(/(?<first_name>.+)\s(?<last_name>\w+)+$/)
    self.first_name = match.try :[], :first_name
    self.last_name = match.try :[], :last_name
  end

  old_avatar_setter = instance_method(:avatar=)

  define_method :'avatar=' do |arg|
    case arg
    when /^data/, NilClass, File
      old_avatar_setter.bind(self).(arg)
    end
  end
end
