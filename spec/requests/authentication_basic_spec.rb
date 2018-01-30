require 'rails_helper'

RSpec.describe 'Basic Authentication', type: :request do
  let(:basic_auth) { ActionController::HttpAuthentication::Basic }

  let(:user) { create(:user) }

  let(:auth_header) { basic_auth.encode_credentials(user.email, user.password) }

  let(:headers) { { 'Authorization' => auth_header, 'Content-type' => 'application/json' } }

  let(:token) { JWTWorker.encode(user_id: user.id) }

  context 'POST /api/auth_tokens' do
    before { post '/api/auth_tokens', headers: headers }

    context 'when email is not found' do
      let(:auth_header) { basic_auth.encode_credentials('incorrect', user.password) }

      it('returns status 404') { expect(response).to have_http_status 404 }
    end

    context 'when password is invalid' do
      let(:auth_header) { basic_auth.encode_credentials(user.email, 'incorrect') }

      it('returns status 401') { expect(response).to have_http_status 401 }
    end

    context 'when email and password are valid' do
      let(:result) { { 'token' => token }.to_json }

      it('returns token') { expect(response.body).to eq result }

      it('returns status 201') { expect(response).to have_http_status 201 }
    end
  end
end
