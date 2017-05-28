class StudySubject::Link < ApplicationRecord
  belongs_to :study_subject

  # FP guys say polymorphic assocs are a "no no",
  # so let's use a foreign_key for each possible type of
  # parent record instead
  with_options inverse_of: :study_subject_links do
    belongs_to :user, required: false
    belongs_to :class_appointment, required: false
  end
end
