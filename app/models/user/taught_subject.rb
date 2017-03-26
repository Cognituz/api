class User::TaughtSubject < ApplicationRecord
  SUBJECTS_BY_LEVEL = {
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
  }

  SUBJECTS_BY_LEVEL_AS_JSON =
    SUBJECTS_BY_LEVEL.map do |lvl, subjects|
      {name: lvl, subjects: subjects}
    end

  LEVELS = SUBJECTS_BY_LEVEL.keys

  belongs_to :user, inverse_of: :taught_subjects

  validates :name, :user, presence: true
  validates :level, inclusion: { in: LEVELS }
  validates :name, inclusion: { in: -> ts { SUBJECTS_BY_LEVEL.fetch(ts.level, []) } }
end
