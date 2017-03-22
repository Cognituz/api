class Location < ApplicationRecord
  NEIGHBORHOODS = %w[
    Agronomía Almagro Balvanera Barracas Belgrano Boedo Caballito Chacarita
    Coghlan Colegiales Constitución Flores Floresta La\ Boca La\ Paternal
    Liniers Mataderos Monserrat Monte\ Castro Nueva\ Pompeya Núñez Palermo
    Parque\ Avellaneda Parque\ Chacabuco Parque\ Chas Parque\ Patricios
    Puerto\ Madero Recoleta Retiro Saavedra San\ Cristóbal San\ Nicolás
    San\ Telmo Vélez\ Sársfield Versalles Villa\ Crespo Villa\ del\ Parque
    Villa\ Devoto Villa\ Gral.\ Mitre Villa\ Lugano Villa\ Luro Villa\ Ortúzar
    Villa\ Pueyrredón Villa\ Real Villa\ Riachuelo Villa\ Santa\ Rita
    Villa\ Soldati Villa\ Urquiza
  ]

  belongs_to :user, inverse_of: :location

  validates :street, :street_number, :city, :user, presence: true
  validates :neighborhood, inclusion: { in: NEIGHBORHOODS }, if: :neighborhood
end
