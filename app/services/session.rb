class Session
  include ActiveModel::Validations
  include ActiveModel::Serialization

  SECRET_KEY = Rails.application.secrets.secret_key_base
  ALGORITHM = 'HS256'.freeze

  def initialize params
    @user = params[:user]
    @exp = params[:exp] || 7.days.from_now.to_i
  end

  def token
    @token ||= JWT.encode payload, SECRET_KEY, ALGORITHM, headers
  end

  private
  def headers
    {
      typ: 'JWT',
      alg: ALGORITHM
    }
  end

  def payload
    {
      id: @user.id,
      exp: @exp
    }
  end
end
