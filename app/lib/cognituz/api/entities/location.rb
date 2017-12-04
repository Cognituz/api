class Cognituz::API::Entities::Location < Cognituz::API::Entities::Base
  expose :id, :latitude, :longitude, :name, :radius, :address, :user_id
end
