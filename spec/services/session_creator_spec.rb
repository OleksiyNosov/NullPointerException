require 'rails_helper'

RSpec.describe SessionCreator do
  it { is_expected.to be_an ResourceCrudWorker }

  let(:password) { SecureRandom.base64(32) }

  let(:user) { FactoryGirl.create(:user, password: password) }

  let(:token) { SecureRandom.base64(64) }

  let(:resource) { Session.new user: user, token: token, password: password }

  subject { SessionCreator.new email: user.email, password: password }

  describe '#process_action' do
    before { allow(User).to receive(:find_by).with(email: user.email).and_return user }

    before { allow(SecureRandom).to receive(:base64).with(64).and_return token }

    before { allow(Session).to receive(:new).with(user: user, token: token, password: password).and_return resource }

    before { expect(resource).to receive(:save) }

    it { expect { subject.send :process_action }.to_not raise_error }
  end

  describe 'call' do
    before { expect(subject).to receive(:process_action) }

    before { expect(subject).to receive(:broadcast_resource) }

    it { expect { subject.call }.to_not raise_error }
  end
end
