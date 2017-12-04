class Cognituz::API::Locations < Grape::API
  version :v1, using: :path

  ENTITY = Cognituz::API::Entities::Location

  helpers do
    params :location_attributes do
      group :locations, type: Hash, default: {} do
        requires :name, type: String
        requires :address, type: String
        requires :radius, type: Integer
        requires :latitude
        requires :longitude
        requires :user_id
      end
    end
  end

  resources :locations do
    desc "Creates a new location"
    params { use :location_attributes }
    post do
      attributes = declared(params).fetch(:locations)
      location = Location.new(attributes)
      location.save!
      present location, with: ENTITY
    end

    route_param :id do
      desc "Retrieves a single location"
      get { present Location.find(params.fetch(:id)), with: ENTITY }

      desc "Updates a location"
      params { use :location_attributes }
      put do
        attributes = declared(params).fetch(:locations)
        location = Location.find(params.fetch(:id))
        location.update!(attributes)
        present location, with: ENTITY
      end
    end
  end
end
