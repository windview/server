Rails.application.routes.draw do
  get '/apidocs' => redirect('/swagger/dist/index.html?url=/openapi.json')
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
