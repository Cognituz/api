class CognituzApi::API::Users < Grape::API
  version :v1, using: :path

  resources :users do
    get {
      User::Search.run(User, params[:filters] || {}).all
    }

    route_param :id do
      get { User.find params.fetch(:id) }

      params do
        requires :user, type: Hash do
          with coerce: String do
            optional :avatar
            optional :first_name
            optional :last_name
            optional :school_year
            optional :phone_number
            optional :age
            optional :description
          end
        end
      end

      put do
        user = User.find params.fetch(:id)

        handle_resource_action(user) do |u|
          u.update declared(params).fetch(:user)
        end
      end
    end
  end
end
