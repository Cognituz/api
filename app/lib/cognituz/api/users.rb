class Cognituz::API::Users < Grape::API
  version :v1, using: :path
  before { ensure_authenticated! }

  ENTITY = Cognituz::API::Entities::User

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

        optional :taught_subject_ids, type: Array[Integer]
        optional :neighborhoods, type: Array[String]
        optional :available_at, type: Hash do
          requires :date, coerce: Date
          requires :duration, coerce: Integer
        end
      end
    end

    get do
      filters    = declared(params, include_missing: false).fetch(:filters)
      base_query = User.includes(
        :taught_subjects,
        :availability_periods,
        :locations,
        :mercado_pago_credential
      ).where.not(hourly_price: nil, locations: { name: nil})
      users = User::Search.run(base_query, filters).all

      present paginate(users), with: ENTITY
    end

    route_param :id do
      get do
        user = User.find params.fetch(:id)
        present user, with: ENTITY
      end

      params do
        group :user, type: Hash do
          optional :avatar, :first_name, :last_name, :school_year,
            :phone_number, :age, :description, :short_desc, :long_desc, coerce: String

          optional :teaches_online, :teaches_at_own_place,
            :teaches_at_students_place, :teaches_at_public_place,
            coerce: Boolean

          optional :neighborhoods, type: Array
          optional :hourly_price, type: Integer
          optional :taught_subject_ids, type: Array[Integer]
          optional :availability_periods_attributes, type: Array do
            optional :id, :week_day, coerce: Integer
            requires :starts_at, :ends_at, coerce: DateTime
            optional :_destroy, coerce: Boolean
          end
        end
      end

      put do
        User.find(params.fetch(:id)).tap do |u|
          attributes = declared(params).fetch(:user)
          u.update! attributes
          present u, with: ENTITY
        end
      end
    end
  end
end
