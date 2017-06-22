# Acts as a model. Actually generates payment preferences using MercadoPago API.
require 'mercadopago.rb'

module Cognituz
  module MercadoPago
    class PaymentPreference
      include ActiveModel::Model
      attr_accessor :external_ref, :items, :access_token

      EDUCANDOANDO_FEE = 6.5

      def create
        resp   = client.create_preference(pref_data)
        status = resp.fetch("status").to_i

        if (200..299).include? status
          pref = resp.fetch("response")

          {
            init_point: (
              Rails.env.production? ?
                pref.fetch("init_point") :
                pref.fetch("sandbox_init_point")
            ),
            status:        status,
            original_data: pref
          }
        else
          resp.fetch("response")
            .slice(*%w[message error cause])
            .symbolize_keys!
            .merge(status: status)
        end
      end

      def create!
        create.tap do |pref|
          unless (200..299).include? pref.fetch(:status)
            raise "Could not generate mercado pago payment preference"
          end
        end
      end

      private

      def pref_data
        @pref_data ||= {
          external_reference: external_ref,
          items:              items_for_mp,
          marketplace_fee:    fee_amount
        }
      end

      def items_for_mp
        @items_for_mp ||= items.map { |i| i.merge(currency_id: :ARS) }
      end

      def fee_amount
        @fee_amount ||= items_for_mp.sum { |i| i.fetch(:unit_price) } / 100.0 * EDUCANDOANDO_FEE
      end

      def client()
        @client ||=
          ::MercadoPago.new(access_token).tap do |c|
            c.sandbox_mode(false)
          end
      end
    end
  end
end
