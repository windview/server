# config/initializers/swagger_ui_engine.rb

SwaggerUiEngine.configure do |config|
  #config.swagger_url = '/api/swagger.yaml'
  config.swagger_url = {
    v1: '/docs/v1/spec.json',
    v2: '/docs/v2/swagger.yaml'
  }
end
