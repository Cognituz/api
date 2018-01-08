ActiveAdmin.register ClassAppointment do
  permit_params :kind, :place_desc, :desc, :teacher_id, :student_id, :status,
    :starts_at, :ends_at

  menu label: 'Clases', priority: 2

  index title: 'Clases' do
    selectable_column
    id_column
    column :kind
    column :place_desc
    column :desc
    column :teacher_id
    column :student_id
    column :status
    column :starts_at
    column :ends_at
    column :created_at
    column() {|appointment| link_to 'Vivo', "http://staging.cognituz.com/app/s/clases/#{appointment.id}/aula_virtual"}
    actions
  end

  filter :kind
  filter :place_desc
  filter :desc
  filter :teacher_id
  filter :student_id
  filter :status
  filter :starts_at
  filter :ends_at

  form do |f|
    f.inputs do
      f.input :kind
      f.input :place_desc
      f.input :desc
      f.input :teacher_id
      f.input :student_id
      f.input :starts_at
      f.input :ends_at
      f.input :status
    end
    f.actions
  end

end
