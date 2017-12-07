class Session
  include ActiveModel::Validations
  include ActiveModel::Serialization

  SECRET_KEY = Rails.application.secrets.secret_key_base
  ALGORITHM = 'HS256'.freeze

  def initialize params
    @email = params[:email]
    @password = params[:password]
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
      id: user&.id,
      exp: @exp
    }
  end

  validate do |model|
    model.errors.add :email, 'not found' unless user
    model.errors.add :password, 'is invalid' unless user&.authenticate @password
  end

  def user
    @user ||= User.find_by email: @email
  end
end
