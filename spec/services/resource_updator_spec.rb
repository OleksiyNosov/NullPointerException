require 'rails_helper'

RSpec.describe ResourceUpdator do
  let(:resource_attrs) { attributes_for :question }

  let(:resource) { instance_double Question, as_json: resource_attrs, **resource_attrs }

  subject { ResourceUpdator.new resource, resource_attrs }

  it('behaves as resource dispatcher') { is_expected.to be_an ResourceCrudWorker }

  describe '#call' do
    before { allow(resource).to receive(:update).with(resource_attrs).and_return resource }

    context 'when passed valid params' do
      before { be_broadcasted_succeeded resource }

      it('updates and broadcasts resource') { expect { subject.call }.to_not raise_error }
    end

    context 'when passed invalid params' do
      let(:resource) { instance_double Question, errors: { errors: %w[error1 error2] } }

      before { be_broadcasted_failed resource }

      it('broadcasts resource errors') { expect { subject.call }.to_not raise_error }
    end
  end
end
