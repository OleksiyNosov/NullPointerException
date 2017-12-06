class Session
  include ActiveModel::Validations
  include ActiveModel::Serialization

  def initialize params
    @user = params[:user]
  end

  def token
    @token ||= JWT.encode payload, secret_key_base, algorithm, headers
  end

  private
  def secret_key_base
    Rails.application.secrets.secret_key_base
  end

  def headers
    {
      typ: 'JWT',
      alg: algorithm,
    }
  end

  def payload
    {
      id: @user.id
    }
  end

  def algorithm
    'HS256'
  end
end
