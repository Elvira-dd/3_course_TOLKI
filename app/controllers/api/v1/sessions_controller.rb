class Api::V1::SessionsController < Devise::SessionsController
    skip_before_action :verify_authenticity_token, only: [:create, :destroy]
  skip_before_action :verify_signed_out_user, only: :destroy
  before_action :load_user, only: :create

  def create
    if @user.valid_password?(sign_in_params[:password])
      render json: {
        messages: "Signed In Successfully",
        is_success: true,
        jwt: encrypt_payload
      }, status: :ok
    else
      render json: {
        messages: "Sign In Failed - Unauthorized",
        is_success: false
      }, status: :unauthorized
    end
  end

  def destroy
    @user = User.find_by_jti(decrypt_payload[0]['jti'])

    if @user && @user.update_column(:jti, SecureRandom.uuid)
      render json: {
        messages: "Signed Out Successfully",
        is_success: true
      }, status: :ok
    else
      render json: {
        messages: "Sign Out Failed - Unauthorized",
        is_success: false
      }, status: :unauthorized
    end
  end

  private

    def sign_in_params
      params.require(:user).permit(:email, :password)
    end

    def load_user
      @user = User.find_for_database_authentication(email: sign_in_params[:email])

      unless @user
        render json: {
          messages: "Sign In Failed - Unauthorized",
          is_success: false
        }, status: :unauthorized
      end
    end

    def encrypt_payload
      payload = @user.as_json(only: [:email, :jti])
      token = JWT.encode(payload, Rails.application.credentials.devise_jwt_secret_key!, 'HS256')
    end

    def decrypt_payload
      jwt = request.headers["Authorization"]
      token = JWT.decode(jwt, Rails.application.credentials.devise_jwt_secret_key!, true, { algorithm: 'HS256' })
    end

end