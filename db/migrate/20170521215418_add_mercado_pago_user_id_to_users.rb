class AddMercadoPagoUserIdToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :mercado_pago_user_id, :integer
  end
end
