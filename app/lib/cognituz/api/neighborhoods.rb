class Cognituz::API::Neighborhoods < Grape::API
  version :v1, using: :path

  resources :neighborhoods do
    get { Location::NEIGHBORHOODS }
  end
end
