require 'rails_helper'

RSpec.describe Api::AuthTokensController, type: :controller do
  it { is_expected.to be_an ActionController::API }

  it 'authenticate with basic' do
    is_expected.to be_kind_of ActionController::HttpAuthentication::Basic::ControllerMethods
  end

  it('handles exceptions') { is_expected.to be_kind_of ErrorHandable }

  it('authorize current user') { is_expected.to be_kind_of Pundit }

  let(:basic_auth) { ActionController::HttpAuthentication::Basic }

  let(:user_attrs) { attributes_for :user }

  let(:user) { build_stubbed(:user, **user_attrs) }

  let(:user_password) { user.password }

  let(:token) { JWTWorker.encode user_id: user.id }

  describe 'POST #create' do
    before { request.env['HTTP_AUTHORIZATION'] = basic_auth.encode_credentials(user.email, user_password) }

    context 'when user not found' do
      before { expect(User).to receive(:find_by!).and_raise ActiveRecord::RecordNotFound }

      before { post :create, format: :json }

      it('returns status 404') { expect(response).to have_http_status 404 }
    end

    context 'when user passed invalid password' do
      let(:user_password) { 'incorrect' }

      before { allow(User).to receive(:find_by!).and_return user }

      before { post :create, format: :json }

      it('returns status 401') { expect(response).to have_http_status 401 }

      it('returns header "WWW-Authenticate"') do
        expect(response.header['WWW-Authenticate']).to eq 'Basic realm="Application"'
      end
    end

    context 'with authentication' do
      let(:user) { build_stubbed(:user) }

      before { allow(User).to receive(:find_by!).and_return user }

      context 'when user is invalid' do
        before { expect(subject).to receive(:authorize).and_raise Pundit::NotAuthorizedError }

        before { post :create, format: :json }

        it('returns status 403') { expect(response).to have_http_status 403 }
      end

      context 'when email and password are valid' do
        let(:result) { { 'token' => token }.to_json }

        before { expect(subject).to receive(:authorize) }

        before { post :create, format: :json }

        it('returns status 201') { expect(response).to have_http_status 201 }

        it('returns token') { expect(response.body).to eq result }
      end
    end
  end
end
