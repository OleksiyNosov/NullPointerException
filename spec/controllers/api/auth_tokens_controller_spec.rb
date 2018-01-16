require 'rails_helper'

RSpec.describe Api::AuthTokensController, type: :controller do
  it { is_expected.to be_an ActionController::API }

  it('handles exceptions') { is_expected.to be_kind_of ErrorHandable }

  let(:password) { 'user_password' }

  let(:email) { 'test@example.com' }

  let(:user) do
    instance_double User,
      id: 7,
      email: 'test@example.com',
      password: 'user_password',
      status: 'confirmed',
      confirmed?: true
  end

  let(:token) { JWTWorker.encode user_id: user.id, intent: 'authentication' }

  describe 'POST #create' do
    let(:errors_json) { { 'email' => ['invalid email'], 'password' => ['invalid password'] }.to_json }

    let(:params) { { sign_in: { email: email, password: password } } }

    context 'when email and password are valid' do
      let(:stringified_token) { { token: token }.stringify_keys }

      let(:token_json) { { token: token }.to_json }

      before { allow(subject).to receive(:current_user).and_return user }

      before { allow(user).to receive(:authenticate).and_return true }

      before { post :create, params: params, format: :json }

      it('returns status 201') { expect(response).to have_http_status 201 }

      it('returns token') { expect(response.body).to eq token_json }
    end

    context 'request have invalid structure' do
      before { post :create, params: { invalid_key: { email: email, password: password } }, format: :json }

      it('returns status 400') { expect(response).to have_http_status 400 }
    end

    context 'when not authorized' do
      before { allow(subject).to receive(:current_user).and_return user }

      before { allow(user).to receive(:authenticate).and_return true }

      before { expect(subject).to receive(:authorize).and_raise Pundit::NotAuthorizedError }

      before { post :create, params: params, format: :json }

      it('returns status 403') { expect(response).to have_http_status 403 }
    end

    context 'when email is invalid' do
      let(:email) { 'wrong_user_email' }

      before { post :create, params: params, format: :json }

      it('returns status 403') { expect(response).to have_http_status 403 }
    end

    context 'when password is invalid' do
      let(:password) { 'wrong_user_password' }

      before { post :create, params: params, format: :json }

      it('returns status 403') { expect(response).to have_http_status 403 }
    end
  end

  describe '#current_user' do
    let(:user) { create(:user, password: '123') }

    before { post :create, params: { sign_in: { email: user.email.upcase, password: '123' } }, format: :json }

    it('returns user') { expect(subject.send :current_user).to eq user }
  end
end
