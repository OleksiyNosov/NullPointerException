require 'rails_helper'

RSpec.describe SessionCreator do
  it { is_expected.to be_an ResourceCrudWorker }

  let(:password) { SecureRandom.base64(32) }

  let(:user) { FactoryGirl.create(:user, password: password) }

  let(:token) { SecureRandom.base64(64) }

  let(:session_params) { { email: user.email, password: password } }

  let(:resource) { Session.new session_params }

  subject { SessionCreator.new session_params }

  describe '#process_action' do
    before { allow(Session).to receive(:new).with(session_params).and_return resource }

    it { expect { subject.send :process_action }.to_not raise_error }
  end

  describe 'call' do
    before { expect(subject).to receive(:process_action) }

    before { expect(subject).to receive(:broadcast_resource) }

    it { expect { subject.call }.to_not raise_error }
  end
end
