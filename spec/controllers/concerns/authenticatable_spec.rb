require 'rails_helper'

RSpec.describe Authenticatable do
  subject { ApplicationController.new }

  let(:user) { FactoryGirl.create :user }

  let(:session) { Session.new user: user }

  let(:token) { session.token }

  let(:decoded_token) { JWT.decode token, Session::SECRET_KEY, true, algorithm: Session::ALGORITHM }

  let(:request) { double }

  let(:_options) { double }

  describe '#authenticate' do
    before { expect(subject).to receive(:request).and_return request }

    before do
      allow(ActionController::HttpAuthentication::Token).to \
        receive(:token_and_options).with(request).and_return [token, _options]
    end

    context 'token decoded' do
      before { expect(subject).to receive(:decode_token).with(token).and_return decoded_token }

      before do
        #
        # => decoded_token[0]['id']
        #
        expect(decoded_token).to receive(:[]).with(0) do
          double.tap { |data| expect(data).to receive(:[]).with('id').and_return user.id }
        end
      end

      context 'User was found' do
        before { expect(User).to receive(:find).with(user.id).and_return user }

        it { expect { subject.send :authenticate }.to_not raise_error }
      end

      context 'User was not found' do
        before { expect(User).to receive(:find).with(user.id).and_return nil }

        before { expect(subject).to receive(:render).with(status: 401) }

        it { expect { subject.send :authenticate }.to_not raise_error }
      end
    end

    context 'token was not decoded' do
      before { expect(subject).to receive(:decode_token).with(token).and_return nil }

      before { expect(subject).to receive(:render).with(status: 401) }

      it { expect { subject.send :authenticate }.to_not raise_error }
    end
  end

  describe '#decode_token' do
    let(:jwt_decode_args) { [token, Session::SECRET_KEY, true, algorithm: Session::ALGORITHM] }

    context 'token decoded' do
      before { allow(JWT).to receive(:decode).with(*jwt_decode_args).and_return decoded_token }

      it { expect(subject.send :decode_token, token).to eq decoded_token }
    end

    context 'decode error' do
      let(:token) { 'сссссс' }

      before { allow(JWT).to receive(:decode).with(*jwt_decode_args).and_raise JWT::DecodeError }

      it { expect(subject.send :decode_token, token).to eq nil }
    end

    context 'token expired' do
      let(:session) { Session.new user: user, exp: (Time.zone.now.to_i - 1.days.to_i) }

      before { allow(JWT).to receive(:decode).with(*jwt_decode_args).and_raise JWT::ExpiredSignature }

      it { expect(subject.send :decode_token, token).to eq nil }
    end
  end
end
