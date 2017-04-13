class Cognituz::API::Users < Grape::API
  version :v1, using: :path

  resources :users do
    paginate per_page: 12
    params do
      optional :filters, type: Hash, default: {} do
        optional \
          :is_teacher,
          :teaches_online,
          :teaches_at_own_place,
          :teaches_at_students_place,
          :teaches_at_public_place,
          coerce: Boolean

        optional :taught_subjects, type: Array do
          requires :name, :level, type: String
        end

        optional :neighborhoods, type: Array
      end
    end

    get do
      filters    = declared(params, include_missing: false).fetch(:filters)
      base_query = User.includes(:taught_subjects, :availability_periods, :location)
      users      = User::Search.run(base_query, filters).all

      present paginate(users), with: Cognituz::API::Entities::User
    end

    route_param :id do
      get do
        user = User.find params.fetch(:id)
        present user, with: Cognituz::API::Entities::User
      end

      params do
        group :user, type: Hash do
          optional :avatar, :first_name, :last_name, :school_year,
            :phone_number, :age, :description, :short_desc, :long_desc, coerce: String

          optional :teaches_online, :teaches_at_own_place,
            :teaches_at_students_place, :teaches_at_public_place,
            coerce: Boolean

          optional :location_attributes, type: Hash, default: {} do
            optional :id, :city, :neighborhood,
              :street, :street_number, :notes
          end

          optional :neighborhoods, type: Array

          optional :taught_subjects_attributes, type: Array do
            optional :id
            optional :_destroy, coerce: Boolean
            optional :name, :level, type: String
          end

          optional :availability_periods_attributes, type: Array do
            optional :id, :week_day, :starts_at_sfsow, :ends_at_sfsow, coerce: Integer
            optional :_destroy, coerce: Boolean
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
