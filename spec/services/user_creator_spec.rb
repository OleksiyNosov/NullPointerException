require 'rails_helper'

RSpec.describe UserCreator do
  let(:user_attrs) { attributes_for :user }

  let(:user) { User.new user_attrs }

  subject { UserCreator.new user_attrs }

  it('behaves as resource dispatcher') { is_expected.to be_an ResourceCrudWorker }

  it('publishes resource') { is_expected.to be_kind_of Homie }

  describe '#process action' do
    before { allow(User).to receive(:new).with(user_attrs).and_return user }

    before do
      expect(user_attrs).to receive(:[]).with(:email) do
        double.tap { |email| expect(email).to receive(:downcase!) }
      end
    end

    context 'when user attributes are valid' do
      let(:additional_attrs) { { notification: :registration, token: 'user_token' } }

      before { allow(user).to receive(:save).and_return true }

      before { allow(JWTWorker).to receive(:encode).and_return 'user_token' }

      before do
        allow(ActiveModelSerializers::SerializableResource).to receive(:new) do
          double.tap do |serialized_user|
            allow(serialized_user).to receive(:as_json) do
              double.tap do |as_json|
                allow(as_json).to receive(:merge).with(additional_attrs).and_return :attrs_for_publish
              end
            end
          end
        end
      end

      before { expect(UserPublisher).to receive(:publish).with(:attrs_for_publish) }

      it('creates user and publish their attributes') { expect { subject.send :process_action }.to_not raise_error }
    end

    context 'when user attributes are invalid' do
      before { allow(user).to receive(:save).and_return false }

      it('do not saves user to db and skips publish') { expect { subject.send :process_action }.to_not raise_error }
    end
  end

  describe '#call' do
    before { expect(subject).to receive(:process_action) }

    before { expect(subject).to receive(:broadcast_resource) }

    it('creates and broadcasts resource') { expect { subject.call }.to_not raise_error }
  end

  describe  '#broadcast_resource' do
    context 'when resource is valid' do
      before { allow(subject).to receive_message_chain(:resource, :valid?).and_return true }

      before { allow(subject).to receive(:resource).and_return user }

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
end
