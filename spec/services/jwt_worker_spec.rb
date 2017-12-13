require 'rails_helper'

RSpec.describe JWTWorker do
  let(:user) { FactoryBot.create(:user) }

  let(:exp) { 7.days.from_now.to_i }

  let(:payload) { { user_id: user.id, exp: exp } }

  let(:headers) { { alg: 'HS256' } }

  let(:token) { JWTWorker.encode payload }

  let(:decoded_token) { [payload.stringify_keys, headers.stringify_keys] }

  describe '.decode' do
    context 'all is good' do
      it('returns decoded token') { expect(JWTWorker.decode token).to eq decoded_token }
    end

    context 'token expired' do
      let(:exp) { Time.zone.now.to_i - 5.minutes.to_i }

      it('returns decoded token') { expect(JWTWorker.decode token).to eq false }
    end

    context 'token is invalid' do
      let(:token) { 'bad_token_value' }

      it('returns decoded token') { expect(JWTWorker.decode token).to eq false }
    end
  end
end
