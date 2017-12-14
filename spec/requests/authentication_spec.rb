require 'acceptance_helper'

RSpec.describe 'Authentication', type: :request do
  let(:user) { FactoryBot.create(:user) }

  let(:user_json) { { id: user.id, email: user.email }.stringify_keys }

  let(:user_id) { user.id }

  let(:token) { JWTWorker.encode(user_id: user_id) }

  let(:headers) { { 'Authorization' => "Bearer #{ token }", 'Content-type' => 'application/json' } }

  before { get '/api/profile', params: {}, headers: headers }

  context 'with valid params' do
    it { expect(response_body).to eq user_json }

    it { expect(response).to have_http_status 200 }
  end

  context 'with invalid params' do
    let(:token) { 'invalid token' }

    it { expect(response.body).to eq "HTTP Token: Access denied.\n" }

    it { expect(response.header['WWW-Authenticate']).to eq 'Token realm="Application"' }

    it { expect(response).to have_http_status 401 }
  end
end
