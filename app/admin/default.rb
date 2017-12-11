ActiveAdmin.register Default do
  permit_params :hourly_price

  menu label: 'Configurar', priority: 4

  index title: 'Default' do
    selectable_column
    id_column
    column :hourly_price
    actions
  end

  form do |f|
    f.inputs do
      f.input :hourly_price
    end
    f.actions
  end

end
