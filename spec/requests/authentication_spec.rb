require 'acceptance_helper'

RSpec.describe 'Authentication', type: :request do
  let(:user) { create(:user) }

  let(:user_json) do
    { id: user.id,
      email: user.email,
      first_name: user.first_name,
      last_name: user.last_name
    }.to_json
  end

  let(:token) { JWTWorker.encode(user_id: user.id, intent: 'authentication') }

  let(:headers) { { 'Authorization' => "Bearer #{ token }", 'Content-type' => 'application/json' } }

  context 'GET /api/profile' do
    before { get '/api/profile', params: {}, headers: headers }

    context 'with valid params' do
      it('returns user profile') { expect(response.body).to eq user_json }

      it('returns status 200') { expect(response).to have_http_status 200 }
    end

    context 'with invalid params' do
      let(:token) { 'invalid token' }

      it('returns "HTTP Token: Access denied."') { expect(response.body).to eq "HTTP Token: Access denied.\n" }

      it('returns header "WWW-Authenticate"') do
        expect(response.header['WWW-Authenticate']).to eq 'Token realm="Application"'
      end

      it('returns status 401') { expect(response).to have_http_status 401 }
    end
  end
end
