require 'rails_helper'

RSpec.describe Api::AuthTokensController, type: :controller do
  it { is_expected.to be_an ActionController::API }

  it('handles exceptions') { is_expected.to be_kind_of ErrorHandable }

  it('authorize current user') { is_expected.to be_kind_of Pundit }

  let(:user_attrs) { attributes_for :user }

  let(:user) { instance_double User, id: 7, **user_attrs }

  let(:token) { JWTWorker.encode user_id: user.id }

  describe 'POST #create' do
    context 'when user not found' do
      before { expect(subject).to receive(:authenticate).and_raise ActiveRecord::RecordNotFound }

      before { post :create, format: :json }

      it('returns status 404') { expect(response).to have_http_status 404 }
    end

    context 'when user not authenticated' do
      before { allow(User).to receive(:find_by!).and_return user }

      before { allow(user).to receive(:authenticate).and_return false }

      before { post :create, format: :json }

      it('returns status 401') { expect(response).to have_http_status 401 }

      it('returns header "WWW-Authenticate"') do
        expect(response.header['WWW-Authenticate']).to eq 'Token realm="Application"'
      end
    end

    context 'when not authorized' do
      before { expect(subject).to receive(:authenticate) }

      before { expect(subject).to receive(:authorize).and_raise Pundit::NotAuthorizedError }

      before { post :create, format: :json }

      it('returns status 403') { expect(response).to have_http_status 403 }
    end

    context 'when email and password are valid' do
      let(:token_json) { { 'token' => token }.to_json }

      before { allow(subject).to receive(:current_user).and_return user }

      before { expect(subject).to receive(:authenticate) }

      before { expect(subject).to receive(:authorize) }

      before { post :create, format: :json }

      it('returns status 201') { expect(response).to have_http_status 201 }

      it('returns token') { expect(response.body).to eq token_json }
    end
  end
end
