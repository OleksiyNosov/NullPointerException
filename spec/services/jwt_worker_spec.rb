require 'rails_helper'

RSpec.describe JwtWorker do
  let(:user) { FactoryBot.create(:user) }

  let(:exp) { 7.days.from_now.to_i }

  let(:payload) { { user_id: user.id, exp: exp } }

  let(:secret) { Rails.application.secrets.secret_key_base }

  let(:algorithm) { 'HS256' }

  let(:headers) { { alg: algorithm } }

  let(:token) { JWT.encode payload, secret, algorithm }

  let(:decoded_token) { [payload.stringify_keys, headers.stringify_keys] }

  describe '.encode' do
    it('returns encoded token') { expect(JwtWorker.encode payload).to eq token }
  end

  describe '.decode' do
    context 'all is good' do
      it('returns decoded token') { expect(JwtWorker.decode token).to eq decoded_token }
    end

    context 'token expired' do
      let(:exp) { - 5.minutes.from_now.to_i }

      it('returns decoded token') { expect(JwtWorker.decode token).to eq false }
    end

    context 'token is invalid' do
      let(:token) { 'bad_token_value' }

      it('returns decoded token') { expect(JwtWorker.decode token).to eq false }
    end
  end
end
