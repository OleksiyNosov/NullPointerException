require 'rails_helper'

RSpec.describe Api::AuthTokensController, type: :controller do
  let(:password) { 'user_password' }

  let(:email) { 'test@example.com' }

  let(:user) { FactoryBot.create(:user, email: 'test@example.com', password: 'user_password') }

  let(:exp) { 7.days.from_now.to_i }

  let(:token) { JwtWorker.encode user_id: user.id, exp: exp }

  describe 'POST #create' do
    let(:stringified_errors) { { 'errors' => { 'message' => 'email or password is invalid' } } }

    let(:params) { { sign_in: { email: email, password: password } } }

    before { allow(user).to receive(:email).and_return email }

    before { post :create, params: params, format: :json }

    context 'email and params is valid' do
      let(:stringified_token) { { token: token }.stringify_keys }

      it('returns status 201') { expect(response).to have_http_status 201 }

      it('returns token') { expect(response_body).to eq stringified_token }
    end

    context 'email is invalid' do
      let(:email) { 'wrong_user_email' }

      it('returns status 422') { expect(response).to have_http_status 422 }

      it('returns errors') { expect(response_body).to eq stringified_errors }
    end

    context 'password is invalid' do
      let(:password) { 'wrong_user_password' }

      it('returns status 422') { expect(response).to have_http_status 422 }

      it('returns errors') { expect(response_body).to eq stringified_errors }
    end
  end
end
