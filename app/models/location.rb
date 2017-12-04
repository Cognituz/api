class Location < ApplicationRecord
  belongs_to :user, inverse_of: :locations
end
