class CreateMercadoPagoCredentials < ActiveRecord::Migration[5.0]
  def change
    create_table :mercado_pago_credentials do |t|
      t.references :user, foreign_key: true
      t.string :access_token
      t.string :public_key
      t.string :refresh_token
      t.timestamps null: false
    end
  end
end
