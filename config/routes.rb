Rails.application.routes.draw do
  mount Cognituz::API, at: '/'
end
