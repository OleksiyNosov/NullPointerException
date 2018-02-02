require 'rails_helper'

RSpec.describe UserUpdator do
  let(:resource_attrs) { attributes_for :user }

  let(:resource) { instance_double User, id: 5, as_json: resource_attrs, **resource_attrs }

  subject { UserUpdator.new resource, resource_attrs }

  it('behaves as resource dispatcher') { is_expected.to be_an ResourceCrudWorker }

  describe '#call' do
    before { allow(subject).to receive(:resource).and_return resource }

    before do
      expect(resource_attrs).to receive(:[]).with(:email) do
        double.tap { |email| expect(email).to receive(:downcase!) }
      end
    end

    before { expect(resource).to receive(:update).with(resource_attrs) }

    context 'when passed valid params' do
      before { be_broadcasted_succeeded resource }

      it('updates and broadcasts user') { expect { subject.call }.to_not raise_error }
    end

    context 'when passed invalid params' do
      let(:resource) { user_invalid_double }

      before { be_broadcasted_failed resource }

      it('broadcasts user errors') { expect { subject.call }.to_not raise_error }
    end
  end
end
