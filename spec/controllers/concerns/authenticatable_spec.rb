require 'rails_helper'

RSpec.describe Authenticatable do
  it { is_expected.to be_kind_of ActionController::HttpAuthentication::Token::ControllerMethods }

  subject { ApplicationController.new }

  let(:user) { FactoryBot.create :user }

  let(:payload) { { user_id: user.id } }

  let(:headers) { { alg: 'HS256' } }

  let(:token) { JwtWorker.encode payload }

  let(:decoded_token) { [payload.stringify_keys, headers.stringify_keys] }

  describe '#authenticate' do
    before { expect(subject).to receive(:authenticate_or_request_with_http_token) }

    it { expect { subject.send :authenticate }.to_not raise_error }
  end
end
