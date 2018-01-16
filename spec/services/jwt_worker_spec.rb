require 'rails_helper'

RSpec.describe JWTWorker do
  let(:user) { instance_double User, id: 7 }

  let(:exp) { 7.days.from_now.to_i }

  let(:payload) { { user_id: user.id, exp: exp } }

  let(:token) { JWTWorker.encode payload }

  describe '.decode' do
    context 'without intent' do
      context 'when token is valid' do
        it('returns decoded token') { expect(JWTWorker.decode(token).first).to eq payload }
      end

      context 'when token expired' do
        let(:exp) { Time.zone.now.to_i - 5.minutes.to_i }

        it('returns false') { expect(JWTWorker.decode token).to eq false }
      end

      context 'when token is invalid' do
        let(:token) { 'bad_token_value' }

        it('returns false') { expect(JWTWorker.decode token).to eq false }
      end
    end

    context 'with intent' do
      let(:payload) { { user_id: user.id, exp: exp, intent: 'some_intent' } }

      context 'when token is valid' do
        it('returns decoded token') { expect(JWTWorker.decode(token, intent: 'some_intent').first).to eq payload }
      end

      context 'when token have some unexpected intent' do
        it('returns false') { expect(JWTWorker.decode(token, intent: 'different_intent')).to eq false }
      end

      context 'when token decoded without passed intent' do
        it('returns false') { expect(JWTWorker.decode(token)).to eq false }
      end
    end
  end
end
