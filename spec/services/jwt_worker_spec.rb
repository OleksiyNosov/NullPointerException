require 'rails_helper'

RSpec.describe JWTWorker do
  let(:user) { instance_double User, id: 7 }

  let(:exp) { 7.days.from_now.to_i }

  let(:payload) { { user_id: user.id, exp: exp } }

  let(:token) { JWTWorker.encode payload }

  let(:decoded_payload) { payload.stringify_keys }

  describe '.decode' do
    context 'all is good' do
      it('returns decoded token') { expect(JWTWorker.decode(token).first).to eq decoded_payload }
    end

    context 'token expired' do
      let(:exp) { Time.zone.now.to_i - 5.minutes.to_i }

      it('returns false') { expect(JWTWorker.decode token).to eq false }
    end

    context 'token is invalid' do
      let(:token) { 'bad_token_value' }

      it('returns false') { expect(JWTWorker.decode token).to eq false }
    end
  end
end
