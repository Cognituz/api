class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  mount_base64_uploader :avatar, AvatarUploader
  process_in_background :avatar
  store_in_background :avatar

  def name=(str)
    match = str.match(/(?<first_name>.+)\s(?<last_name>\w+)+$/)
    self.first_name = match.try :[], :first_name
    self.last_name = match.try :[], :last_name
  end
end
