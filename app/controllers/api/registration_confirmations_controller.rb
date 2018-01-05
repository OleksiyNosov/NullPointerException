class Api::RegistrationConfirmationsController < ActionController::API
  include ErrorHandable

  def show
    if (decoded_token = JWTWorker.decode params[:id]) && (user = User.find decoded_token.first['user_id'])
      user.update status: :confirmed

      head 200
    else
      head 404
    end
  end
end
