Rails.application.routes.draw do
  get '/apidocs' => redirect('/swagger/dist/index.html?url=/openapi.json')
  scope "api" do

    resources :farm_providers
    resources :farms

    resources :forecast_providers
    resources :forecast_types

    get '/forecasts/latest', to: 'forecasts#latest'
    resources :forecasts
    resources :actuals
  end
end
