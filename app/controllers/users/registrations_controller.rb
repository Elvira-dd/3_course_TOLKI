class Users::RegistrationsController < Devise::RegistrationsController
  protected

  # Редирект после успешной регистрации
  def after_sign_up_path_for(resource)
  profile = resource.profile || Profile.create(user: resource)
  edit_full_profile_path(profile)
end
end