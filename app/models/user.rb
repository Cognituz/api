class User < ApplicationRecord
  include self::Scopes

  has_attached_file :avatar, styles: {original: '250x250#'}

  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable

  with_options dependent: :destroy do
    with_options class_name: :ClassAppointment do
      has_many :appointments_as_teacher, foreign_key: :teacher_id
      has_many :appointments_as_student, foreign_key: :student_id
    end

    with_options inverse_of: :user do
      has_many :study_subject_links, class_name: :"StudySubject::Link"
      has_many :availability_periods
      has_one :location
      has_one :mercado_pago_credential, autosave: true
    end

    has_many :taught_subjects,
      through: :study_subject_links,
      source:  :study_subject
  end

  with_options reject_if: :all_blank do
    accepts_nested_attributes_for :location, :mercado_pago_credential
    accepts_nested_attributes_for \
      :taught_subjects,
      :availability_periods,
      allow_destroy: true
  end

  validates :email, presence: true
  validates_attachment_content_type :avatar,
    content_type: %w[image/jpg image/jpeg image/png image/gif]

  after_create :invitation_email

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

  def name() [first_name, last_name].join(' ') end

  def invitation_email
    if roles.try(:include?, 'teacher')
      UsersMailer.teacher_invite(id).deliver_now
    end
  end
end
