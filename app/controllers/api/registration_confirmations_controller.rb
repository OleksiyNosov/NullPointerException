class Api::RegistrationConfirmationsController < ActionController::API
  include ErrorHandable

  def show
    user = User.find_by! confirmation_token: params[:id]

    user.email_confirmation = true

    head 200
  end
end
