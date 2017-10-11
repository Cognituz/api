def seed_study_subjects
  return if StudySubject.any?

  StudySubject.destroy_all

  {
    "Primario" => %w[
      Matemática
      Cs.\ Naturales
      Cs.\ Sociales
      Informática
      Lengua\ y\ Literatura
    ],

    "Secundario" => %w[
      Matemática
      Física
      Química
      Biología
      Historia
      Geografía
      Informática
      Lengua\ y\ Literatura
      Economía
      Contabilidad
    ],

    "Universitario" => %w[
      Matemática-Ing.
      Física-Ing.
      Química-Ing.
      Informática-Ing.
      Economía-Ing.
      Contabilidad-Ing.
    ],

    nil => %w[
      Inglés
      Francés
      Portugués
      Italiano
    ],

    'CBC' => %w[
      Sociedad\ y\ Estado
      Pensamiento\ Científico
    ]
  }.each do |level, names|
    names.each do |name|
      StudySubject.create!(
        level: level,
        name: name
      )
    end
  end
end

ActiveRecord::Base.transaction do
  seed_study_subjects
end
AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?