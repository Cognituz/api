ActiveAdmin.register User, as: 'Teacher' do
  permit_params :email, :password, :password_confirmation, :last_name, :first_name

  menu label: 'Profesores', priority: 1

  before_create do |user|
    user.roles = ['teacher']
  end

  index title: 'Profesores' do
    selectable_column
    id_column
    column :first_name
    column :last_name
    column :email
    column :created_at
    actions
  end

  controller do
    def scoped_collection
      @users = User.where("'teacher' = ANY (roles)")
    end
  end

  filter :first_name
  filter :last_name
  filter :email
  filter :created_at

  form do |f|
    f.inputs do
      f.input :first_name
      f.input :last_name
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

end
