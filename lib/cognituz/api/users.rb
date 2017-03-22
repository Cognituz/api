class Cognituz::API::Users < Grape::API
  version :v1, using: :path

  resources :users do
    paginate per_page: 8
    get do
      users = User::Search.run(User, params[:filters] || {}).all
      present paginate(users), with: Cognituz::API::Entities::User
    end

    route_param :id do
      get do
        user = User.find params.fetch(:id)
        present user, with: Cognituz::API::Entities::User
      end

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
            optional :id
            optional :city
            optional :neighborhood
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
          present u, with: Cognituz::API::Entities::User
        end
      end
    end
  end
end
