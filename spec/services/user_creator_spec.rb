require 'rails_helper'

RSpec.describe UserCreator do
  let(:resource_attrs) { attributes_for :user, status: :not_confirmed }

  let(:resource) { instance_double User, id: 5, as_json: resource_attrs, **resource_attrs }

  subject { UserCreator.new resource_attrs }

  it('behaves as resource dispatcher') { is_expected.to be_an ResourceCrudWorker }

  describe '#call' do
    before { allow(User).to receive(:new).with(resource_attrs).and_return resource }

    before do
      expect(resource_attrs).to receive(:[]).with(:email) do
        double.tap { |email| expect(email).to receive(:downcase!) }
      end
    end

    context 'when passed valid params' do
      let(:additional_attrs) { { notification: :registration, token: 'user_token' } }

      before { allow(resource).to receive(:save).and_return true }

      before { allow(JWTWorker).to receive(:encode).and_return 'user_token' }

      before do
        allow(subject).to receive(:serialized_resource) do
          resource.as_json.tap do |serialized_resource|
            allow(serialized_resource).to receive(:merge).with(additional_attrs).and_return :attrs_for_publish
          end
        end
      end

      before { expect(UserPublisher).to receive(:publish).with(:attrs_for_publish) }

      before { be_broadcasted_succeeded resource }

      it('creates broacasts and publish user') { expect { subject.call }.to_not raise_error }
    end

    context 'when passed invalid params' do
      let(:resource) { instance_double User, errors: { errors: %w[error1 error2] } }

      before { allow(resource).to receive(:save).and_return false }

      before { be_broadcasted_failed resource }

      it('broacasts user errors') { expect { subject.call }.to_not raise_error }
    end
  end
end
