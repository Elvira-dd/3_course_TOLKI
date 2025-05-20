class Api::V1::BaseController < ActionController::API
  before_action :authenticate_user!
  before_action do
  Rails.logger.info "💥 AUTHORIZATION HEADER: #{request.headers['Authorization']}"
  Rails.logger.info "💥 current_user: #{current_user&.email || 'nil'}"
end

  def authenticate_guest; end # глушим родительское

  rescue_from CanCan::AccessDenied do
    head :forbidden
  end
  
end