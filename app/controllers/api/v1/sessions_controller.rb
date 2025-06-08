class Api::V1::SessionsController < Devise::SessionsController
  skip_before_action :verify_authenticity_token, only: [:create, :destroy, :create_comment]
  skip_before_action :verify_signed_out_user, only: :destroy
  before_action :load_user, only: :create
  before_action :set_active_storage_host

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
  Rails.logger.info("Payload: #{payload.inspect}")

  if payload && payload[0]['jti'].present?
    @user = User.find_by(jti: payload[0]['jti'])

    if @user && @user.update_column(:jti, SecureRandom.uuid)
      render json: { messages: "Signed Out Successfully", is_success: true }, status: :ok
    else
      render json: { messages: "Sign Out Failed - Unauthorized", is_success: false }, status: :unauthorized
    end
  else
    render json: { messages: "Sign Out Failed - Invalid or Missing Token", is_success: false }, status: :unauthorized
  end
end

  def me
  payload = decrypt_payload

  if payload
    user = User.includes(:profile, :author, profile: { avatar_attachment: :blob }, comments: []).find_by(jti: payload[0]['jti'])

    if user
      render json: {
        id: user.id,
        email: user.email,
        profile: user.profile ? {
          name: user.profile.name,
          bio: user.profile.bio,
          level: user.profile.level,
          avatar_url: user.profile.avatar.attached? ? url_for(user.profile.avatar) : nil
        } : nil,
        author: user.author ? {
          id: user.author.id,
          exten_bio: user.author.exten_bio
        } : nil,
        is_author: user.author.present?,
        comments: user.comments.map do |comment|
          {
            id: comment.id,
            content: comment.content,
            created_at: comment.created_at.strftime('%d.%m'),
            user_name: comment.user.profile.name,
            user_id: comment.user.id
          }
        end
      }, status: :ok
    else
      render json: { error: "User not found" }, status: :unauthorized
    end
  else
    render json: { error: "Invalid or missing token" }, status: :unauthorized
  end
end

  def create_comment
    payload = decrypt_payload

    if payload
      user = User.find_by(jti: payload[0]['jti'])

      return render json: { error: "User not found" }, status: :unauthorized unless user

      commentable_type = params[:comment][:commentable_type]
      commentable_id   = params[:comment][:commentable_id]

      commentable = commentable_type.constantize.find_by(id: commentable_id)
      return render json: { error: "Commentable not found" }, status: :not_found unless commentable

      comment = commentable.comments.new(comment_params.merge(user_id: user.id))

      if comment.save
        render json: comment, status: :created
      else
        render json: { errors: comment.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: "Invalid or missing token" }, status: :unauthorized
    end
  end

  def update_me
    payload = decrypt_payload

    unless payload && payload[0]['jti'].present?
      return render json: { error: "Invalid or missing token" }, status: :unauthorized
    end

    user = User.includes(:profile).find_by(jti: payload[0]['jti'])
    return render json: { error: "User not found" }, status: :unauthorized unless user

    profile = user.profile
    if profile.update(profile_params)
      render json: profile, status: :ok
    else
      render json: { errors: profile.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private
  def profile_params
    params.require(:profile).permit(:name, :bio, :level, :avatar)
  end

  def set_active_storage_host
    ActiveStorage::Current.url_options = { host: request.base_url }
  end

  def sign_in_params
    params.permit(:email, :password, :format, session: {})
  end

  def load_user
    @user = User.find_for_database_authentication(email: sign_in_params[:email])
    render json: { messages: "Sign In Failed - Unauthorized", is_success: false }, status: :unauthorized unless @user
  end

  def encrypt_payload
    payload = {
      sub: @user.id,
      email: @user.email,
      jti: @user.jti,
      exp: 24.hours.from_now.to_i
    }
    JWT.encode(payload, Rails.application.credentials.devise_jwt_secret_key!, 'HS256')
  end

  def decrypt_payload
    jwt = request.headers["Authorization"]&.split(' ')&.last
    return nil unless jwt

    begin
      JWT.decode(jwt, Rails.application.credentials.devise_jwt_secret_key!, true, { algorithm: 'HS256' })
    rescue JWT::DecodeError
      nil
    end
  end

  def comment_params
    params.require(:comment).permit(:content, :comment_id, :commentable_type, :commentable_id)
  end
end