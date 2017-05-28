class Cognituz::API::StudySubjects < Grape::API
  version :v1, using: :path
  formatter :json, Grape::Formatter::Json
  resources :study_subjects do
    get { StudySubject.all }
  end
end
