require 'rails_helper'

RSpec.describe UserCreator do
  let(:user_attrs) { attributes_for :user }

  let(:user) { User.new user_attrs }

  subject { UserCreator.new user_attrs }

  it('behaves as resource dispatcher') { is_expected.to be_an ResourceCrudWorker }

  describe '#process action' do
    context 'when user attributes are valid' do
      before { allow(user).to receive(:save).and_return true }

      before { expect(RegistrationMailer).to receive(:deliver) }

      it('creates user and sends registration email') { expect { subject.send :process_action }.to_not raise_error }
    end

    context 'when user attributes are invalid' do
      let(:user_attrs) { nil }

      before { allow(user).to receive(:save).and_return false }

      before { expect(RegistrationMailer).not_to receive(:deliver) }

      it('do not saves user to db and skips mailing') { expect { subject.send :process_action }.to_not raise_error }
    end
  end

  describe '#call' do
    before { expect(subject).to receive(:process_action) }

    before { expect(subject).to receive(:broadcast_resource) }

    it('create and broadcast resource') { expect { subject.call }.to_not raise_error }
  end

  describe  '#broadcast_resource' do
    context 'when resource is valid' do
      before { allow(subject).to receive_message_chain(:resource, :valid?).and_return true }

      before { allow(subject).to receive(:resource).and_return user }

      before { expect(subject).to receive(:broadcast).with(:succeeded, user) }

      it('broadcast resource') { expect { subject.send :broadcast_resource }.to_not raise_error }
    end

    context 'when resource is invalid' do
      let(:user_errors) { double }

      before { allow(subject).to receive_message_chain(:resource, :valid?).and_return false }

      before { allow(subject).to receive_message_chain(:resource, :errors).and_return user_errors }

      before { expect(subject).to receive(:broadcast).with(:failed, user_errors) }

      it('broadcast resource errors') { expect { subject.send :broadcast_resource }.to_not raise_error }
    end
  end
end
