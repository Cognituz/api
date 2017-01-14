Rails.application.routes.draw do
  mount CognituzApi::API, at: '/'
end
