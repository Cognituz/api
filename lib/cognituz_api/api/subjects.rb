class CognituzApi::API::Subjects < Grape::API
  version :v1, using: :path

  resources :subjects do
    get { render User::TaughtSubject::SUBJECTS_BY_LEVEL }
  end
end
