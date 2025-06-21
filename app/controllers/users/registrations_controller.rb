class Users::RegistrationsController < Devise::RegistrationsController
  protected

  # Редирект после успешной регистрации
  def after_sign_up_path_for(resource)
    setting_reg_path
  end
end