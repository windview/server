class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: Proc.new{|e|
    render status: 404, json: { errors: { detail: "Resource not found" } }
  }
end
