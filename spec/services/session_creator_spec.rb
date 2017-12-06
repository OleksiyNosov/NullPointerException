require 'rails_helper'

RSpec.describe SessionCreator do
  it { is_expected.to be_an ResourceCrudWorker }

  let(:password) { SecureRandom.base64(32) }

  let(:user) { FactoryGirl.create(:user, password: password) }

  let(:token) { SecureRandom.base64(64) }

  let(:resource) { Session.new user: user, token: token }

  subject { SessionCreator.new email: user.email, password: password }

  describe '#process_action' do
    before { allow(User).to receive(:find_by).with(email: user.email).and_return user }

    before { allow(Session).to receive(:new).with(user: user).and_return resource }

    context 'was authenticated' do
      before { expect(user).to receive(:authenticate).with(password).and_return true }

      it { expect { subject.send :process_action }.to_not raise_error }
    end

    context 'was not authenticated' do
      before { allow(user).to receive(:authenticate).with(password).and_return false }

      before do
        #
        # => resource.errors.add
        #
        expect(resource).to receive(:errors) do
          double.tap { |errors| expect(errors).to receive(:add).with(:password, 'is invalid') }
        end
      end

      it { expect { subject.send :process_action }.to_not raise_error }
    end
  end

  describe 'call' do
    before { expect(subject).to receive(:process_action) }

    before { expect(subject).to receive(:broadcast_resource) }

    it { expect { subject.call }.to_not raise_error }
  end
end
