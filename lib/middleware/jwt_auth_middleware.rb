class JwtAuthMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    if env['HTTP_AUTHORIZATION'].present?
      token = env['HTTP_AUTHORIZATION'].split(' ').last
      begin
        payload = Warden::JWTAuth::TokenDecoder.new.call(token)
        user = User.find(payload['sub']) # или payload['id'] если ты вручную ставишь
        env['warden'].set_user(user, scope: :user)
      rescue => e
        Rails.logger.warn "JWT decode failed: #{e.message}"
      end
    end

    @app.call(env)
  end
end