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
    payload = decrypt_payload

    if payload
      @user = User.find_by(jti: payload[0]['jti'])

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
    else
      render json: {
        messages: "Sign Out Failed - Invalid or Missing Token",
        is_success: false
      }, status: :unauthorized
    end
  end

  private

  def sign_in_params
    params.permit(:email, :password, :format, session: {})
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
    payload = {
      email: @user.email,
      jti: @user.jti,
      exp: 24.hours.from_now.to_i
    }
    JWT.encode(payload, Rails.application.credentials.devise_jwt_secret_key!, 'HS256')
  end

  def decrypt_payload
    jwt = request.headers["Authorization"]&.split(' ')&.last
    if jwt
      begin
        JWT.decode(jwt, Rails.application.credentials.devise_jwt_secret_key!, true, { algorithm: 'HS256' })
      rescue JWT::DecodeError
        nil
      end
    else
      nil
    end
  end
end