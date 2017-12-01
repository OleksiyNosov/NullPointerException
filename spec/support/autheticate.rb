module Authentication
  def sign_in user = nil
    user ||= User.new

    allow(controller).to receive(:authenticate_with_token).and_return user

    allow(controller).to receive(:current_user).and_return user
  end
end
