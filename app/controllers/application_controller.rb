class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: Proc.new{|e|
    render status: 404, json: { errors: { detail: "#{e.model.titleize.humanize} not found" } }
  }
  rescue_from ActionController::UnpermittedParameters, with: Proc.new{|e|
    render status: 422, json: { errors: { invalid_params: e.params } }
  }
  rescue_from ActiveModel::UnknownAttributeError, with: Proc.new{|e|
    render status: 422, json: { errors: { invalid_params: [ e.attribute ] } }
  }
end
