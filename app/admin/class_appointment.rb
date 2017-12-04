ActiveAdmin.register ClassAppointment do
  permit_params :kind, :place_desc, :desc, :teacher_id, :student_id, :status

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
    column :created_at
    column() {|appointment| link_to 'Vivo', "http://localhost:3333/app/s/clases/#{appointment.id}/aula_virtual"}
    actions
  end

  filter :kind
  filter :place_desc
  filter :desc
  filter :teacher_id
  filter :student_id
  filter :status

  form do |f|
    f.inputs do
      f.input :kind
      f.input :place_desc
      f.input :desc
      f.input :teacher_id
      f.input :student_id
      f.input :status
    end
    f.actions
  end

end
