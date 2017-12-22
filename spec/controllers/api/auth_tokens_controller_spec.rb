require 'rails_helper'

RSpec.describe Api::AuthTokensController, type: :controller do
  it { is_expected.to be_an ActionController::API }

  it('handles exceptions') { is_expected.to be_kind_of Exceptionable }

  let(:password) { 'user_password' }

  let(:email) { 'test@example.com' }

  let(:user) { instance_double User, id: 7, email: 'test@example.com', password: 'user_password' }

  let(:exp) { 7.days.from_now.to_i }

  let(:token) { JWTWorker.encode user_id: user.id, exp: exp }

  describe 'POST #create' do
    let(:errors_json) { { 'errors' => { 'message' => 'email or password is invalid' } }.to_json }

    let(:params) { { sign_in: { email: email, password: password } } }

    context 'email and params is valid' do
      let(:stringified_token) { { token: token }.stringify_keys }

      let(:token_json) { { token: token }.to_json }

      before { allow(User).to receive(:find_by).with(email: email).and_return user }

      before { allow(user).to receive(:authenticate).and_return true }

      before { post :create, params: params, format: :json }

      it('returns status 201') { expect(response).to have_http_status 201 }

      it('returns token') { expect(response.body).to eq token_json }
    end

    context 'email is invalid' do
      let(:email) { 'wrong_user_email' }

      before { post :create, params: params, format: :json }

      it('returns status 422') { expect(response).to have_http_status 422 }

      it('returns errors') { expect(response.body).to eq errors_json }
    end

    context 'bad request parametres' do
      before { post :create, params: { invalid_key: { email: email, password: password } }, format: :json }

      it('returns status 400') { expect(response).to have_http_status 400 }
    end

    context 'password is invalid' do
      let(:password) { 'wrong_user_password' }

      before { post :create, params: params, format: :json }

      it('returns status 422') { expect(response).to have_http_status 422 }

      it('returns errors') { expect(response.body).to eq errors_json }
    end
  end
end
