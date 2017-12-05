require 'rails_helper'

RSpec.describe Authenticatable do
  subject { ApplicationController.new }

  let(:password) { SecureRandom.base64(64) }

  let(:email) { 'test@example.com' }

  let(:user) { instance_double User, id: 5, email: email }

  describe '#authenticate_with_token' do
    let(:request) { double }

    let(:token) { SecureRandom.base64(64) }

    let(:_options) { double }

    before { expect(subject).to receive(:request).and_return request }

    before do
      allow(ActionController::HttpAuthentication::Token).to \
        receive(:token_and_options).with(request).and_return [token, _options]
    end

    context 'User was found' do
      before do
        #
        # => Session.find_by(token: token).user
        #
        expect(Session).to receive(:find_by).with(token: token) do
          double.tap { |session| expect(session).to receive(:user).and_return user }
        end
      end

      it { expect { subject.send :authenticate_with_token }.to_not raise_error }
    end

    context 'User was not found' do
      before do
        #
        # => Session.find_by(token: token).user
        #
        expect(Session).to receive(:find_by).with(token: token) do
          double.tap { |session| expect(session).to receive(:user).and_return nil }
        end
      end

      before { expect(subject).to receive(:render).with(status: 401) }

      it { expect { subject.send :authenticate_with_token }.to_not raise_error }
    end
  end
end
