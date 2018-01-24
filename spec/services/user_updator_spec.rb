require 'rails_helper'

RSpec.describe UserUpdator do
  let(:user_attrs) { attributes_for :user }

  let(:user) { User.new user_attrs }

  subject { UserUpdator.new user, user_attrs }

  it('behaves as resource dispatcher') { is_expected.to be_an ResourceCrudWorker }

  it('publishes resource') { is_expected.to be_kind_of Homie }

  describe '#process action' do
    before { allow(subject).to receive(:resource).and_return user }

    before do
      expect(user_attrs).to receive(:[]).with(:email) do
        double.tap { |email| expect(email).to receive(:downcase!) }
      end
    end

    before { expect(user).to receive(:update).with(user_attrs) }

    it('updates user') { expect { subject.send :process_action }.to_not raise_error }
  end

  describe '#call' do
    before { expect(subject).to receive(:process_action) }

    before { expect(subject).to receive(:broadcast_resource) }

    it('creates and broadcasts resource') { expect { subject.call }.to_not raise_error }
  end

  describe  '#broadcast_resource' do
    context 'when resource is valid' do
      before { allow(subject).to receive_message_chain(:resource, :valid?).and_return true }

      before { allow(subject).to receive(:serialized_resource).and_return user }

      before { expect(subject).to receive(:broadcast).with(:succeeded, user) }

      it('broadcasts resource') { expect { subject.send :broadcast_resource }.to_not raise_error }
    end

    context 'when resource is invalid' do
      let(:user_errors) { double }

      before { allow(subject).to receive_message_chain(:resource, :valid?).and_return false }

      before { allow(subject).to receive_message_chain(:resource, :errors).and_return user_errors }

      before { expect(subject).to receive(:broadcast).with(:failed, user_errors) }

      it('broadcasts resource errors') { expect { subject.send :broadcast_resource }.to_not raise_error }
    end
  end

  describe '#serialized_resource' do
    let(:serialized_resource) { UserSerializer.new(user).as_json }

    before { allow(subject).to receive(:resource).and_return user }

    it('resturns serialized user') { expect(subject.send :serialized_resource).to eq serialized_resource }
  end
end
