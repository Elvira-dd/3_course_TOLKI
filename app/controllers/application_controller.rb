class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :authenticate_guest

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden }
      format.html { redirect_to root_path, alert: exception.message }
    end
  end

  def authenticate_guest 
    if cookies[:guest_token] 
      puts "GUEST TOKEN"
      puts cookies[:guest_token]
    else        
      puts "NO TOKEN"
      cookies[:guest_token] = SecureRandom.uuid
    end 
  end
end
