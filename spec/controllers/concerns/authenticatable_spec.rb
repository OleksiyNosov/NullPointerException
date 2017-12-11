require 'rails_helper'

RSpec.describe Authenticatable do
  subject { ApplicationController.new }

  let(:user) { FactoryGirl.create :user }

  let(:payload) { { user_id: user.id, exp: 7.days.from_now.to_i } }

  let(:headers) { { alg: 'HS256', typ: 'JWT' } }

  let(:token) { JwtWorker.encode payload }

  let(:request) { double }

  let(:decode_token) { [payload.stringify_keys, headers.stringify_keys] }

  describe '#authenticate' do
    before { expect(subject).to receive(:token).and_return token }

    context 'email and password is valid' do
      before { subject.send :authenticate }

      it('sets current_user') { expect(subject.current_user).to eq user }

      it { expect { subject.send :authenticate }.to_not raise_error }
    end

    context 'token is invalid' do
      let(:token) { 'wrong_token' }

      before { expect(subject).to receive(:render).with(header: 'WWW-Authenticate', status: 401) }

      it { expect { subject.send :authenticate }.to_not raise_error }
    end
  end

  describe '#decoded_token' do
    before { expect(subject).to receive(:token).and_return token }

    it('returns decoded token') { expect(subject.send :decoded_token).to eq decode_token }
  end

  describe '#token' do
    before { expect(subject).to receive(:request).and_return request }

    before do
      #
      # => ActionController::HttpAuthentication::Token.token_and_options(:request).first
      #
      allow(ActionController::HttpAuthentication::Token).to \
        receive(:token_and_options).with(request) do
        double.tap { |token_and_options| expect(token_and_options).to receive(:first).and_return token }
      end
    end

    it('returns token') { expect(subject.send :token).to eq token }
  end
end
