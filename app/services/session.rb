class Session
  include ActiveModel::Validations
  include ActiveModel::Serialization

  SECRET_KEY = Rails.application.secrets.secret_key_base
  ALGORITHM = 'HS256'.freeze

  def initialize params
    @user = params[:user]
  end

  def token
    @token ||= JWT.encode payload, SECRET_KEY, ALGORITHM, headers
  end

  private
  def headers
    {
      typ: 'JWT',
      alg: ALGORITHM,
      exp: Time.zone.now.to_i + 7.days.to_i
    }
  end

  def payload
    {
      id: @user.id
    }
  end
end
