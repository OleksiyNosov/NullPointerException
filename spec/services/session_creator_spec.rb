require 'rails_helper'

RSpec.describe SessionCreator do
  it { is_expected.to be_an ResourceCrudWorker }

  let(:user) { FactoryGirl.create(:user) }

  let(:token) { SecureRandom.base64(64) }

  let(:resource) { Session.new user: user, token: token }

  subject { SessionCreator.new user: user }

  describe '#process_action' do
    before { allow(SecureRandom).to receive(:base64).with(64).and_return token }

    before { allow(Session).to receive(:new).with(user: user, token: token).and_return resource }

    before { expect(resource).to receive(:save) }

    it { expect { subject.send :process_action }.to_not raise_error }
  end

  describe 'call' do
    before { expect(subject).to receive(:process_action) }

    before { expect(subject).to receive(:broadcast_resource) }

    it { expect { subject.call }.to_not raise_error }
  end
end
