Rails.application.routes.draw do
  scope "api" do
    resources :actuals
    resources :forecasts
    resources :forecast_providers
    resources :forecast_types
    resources :farms
    resources :farm_providers
  end
end
