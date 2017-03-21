class CognituzApi::API::Users < Grape::API
  version :v1, using: :path

  resources :users do
    get {
      User::Search.run(User, params[:filters] || {}).all
    }

    route_param :id do
      get { User.find params.fetch(:id) }

      params do
        group :user, type: Hash do
          with coerce: String do
            optional :avatar
            optional :first_name
            optional :last_name
            optional :school_year
            optional :phone_number
            optional :age
            optional :description
          end

          optional :location_attributes, type: Hash, default: {} do
            optional :city
            optional :district
            optional :street
            optional :street_number
            optional :notes
          end
        end
      end

      put do
        User.find(params.fetch(:id)).tap do |u|
          attributes = declared(params).fetch(:user)
          u.update! attributes
        end
      end
    end
  end
end
