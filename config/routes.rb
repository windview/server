Rails.application.routes.draw do
  mount SwaggerUiEngine::Engine, at: "/api_docs"
  scope "api" do
    resources :actuals

    get '/forecasts/latest', to: 'forecasts#latest'
    resources :forecasts
    resources :forecast_providers
    resources :forecast_types
    resources :farms
    resources :farm_providers
  end
end
