require 'rails_helper'

RSpec.describe 'Authentication', type: :request do
  let(:user) { FactoryBot.create(:user) }

  let(:serialized_user) { UserSerializer.new(user).to_h.stringify_keys }

  let(:user_id) { user.id }

  let(:token) { JwtWorker.encode(user_id: user_id) }

  let(:headers) { { 'Authorization' => "Bearer #{ token }", 'Content-type' => 'application/json' } }

  before { get '/api/profile', params: {}, headers: headers }

  context 'with valid params' do
    it { expect(response_body).to eq serialized_user }

    it { expect(response).to have_http_status 200 }
  end

  context 'with invalid params' do
    let(:token) { 'invalid token' }

    it { expect(response.body).to eq "HTTP Token: Access denied.\n" }

    it { expect(response).to have_http_status 401 }
  end

  context 'with invalid params' do
    let(:user_id) { -1 }

    it { expect(response).to have_http_status 404 }
  end
end