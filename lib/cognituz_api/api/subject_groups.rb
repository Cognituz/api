class CognituzApi::API::SubjectGroups < Grape::API
  version :v1, using: :path
  formatter :json, Grape::Formatter::Json

  resources :subject_groups do
    get { render User::TaughtSubject::SUBJECTS_BY_LEVEL_AS_JSON }
  end
end
