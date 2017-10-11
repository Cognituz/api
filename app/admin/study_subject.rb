ActiveAdmin.register StudySubject do
  permit_params :level, :name

  menu label: 'Materias', priority: 3

  index title: 'Materias' do
    selectable_column
    id_column
    column :level
    column :name
    column :created_at
    actions
  end

  filter :level
  filter :name
  filter :created_at

  form do |f|
    f.inputs do
      f.input :level
      f.input :name
    end
    f.actions
  end

end
