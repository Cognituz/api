class Cognituz::API::MercadoPago::PaymentPreferences < Grape::API
  EDUCANDOANDO_FEE = 6.5

  helpers do
    def mp_client
      @client ||= MercadoPago.new(teacher.mercado_pago_credential.access_token)
    end

    def ensure_teacher_has_linked_mp_account!
      teacher = User.find_by declared(params).fetch(:teacher_id)
      return if teacher && teacher.mercado_pago_credential.try(:access_token)
      error! "Can't generate payment preference.", 403
    end
  end

  namespace :payment_preferences do
    post do
      params do
        group :payment_preference, type: Hash, default: {} do
          requires :teacher_id, coerce: Integer
          requires :external_reference

          requires :items, type: Array do
            requires :title
            requires :quantity
            requires :unit_price
          end
        end

        params.require(:preference).permit(
          :teacher_id, :external_reference,
          items: %i[title quantity unit_price]
        )
      end

      desc "Creates a MercadoPago payment preference"
      post do
        ensure_teacher_has_linked_mp_account!

        attributes = declared(params).fetch(:payment_preference)

        items      = attributes.fetch(:items).map { |i| i.merge(currency_id: :ARS) }
        subtotal   = items.sum { |i| i.fetch(:unit_price) }
        fee_amount = subtotal / 100.0 * EDUCANDOANDO_FEE

        pref_data = {
          external_reference: attributes.fetch(:external_reference),
          items:              items,
          marketplace_fee:    fee_amount
        }

        pref       = mp_client.create_preference(pref_data).fetch("response")
        init_point = Rails.env.production? ?  pref["init_point"] : pref["sandbox_init_point"]

        render json: { init_point: init_point, full_data: pref }
      end
    end
  end
end
