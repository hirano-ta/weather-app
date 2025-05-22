Rails.application.routes.draw do
  root "weather#index"
  get "weather/search"
end
