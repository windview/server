Rails.application.routes.draw do
  resources :actuals
  resources :forecasts
  resources :forecast_providers
  resources :forecast_types
  resources :farms
  resources :farm_providers
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
