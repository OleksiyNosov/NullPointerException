require 'rails_helper'

RSpec.describe ResourceUpdator do
  let(:resource_attrs) { attributes_for :question }

  let(:resource) { instance_double Question, as_json: resource_attrs, **resource_attrs }

  subject { ResourceUpdator.new resource, resource_attrs }

  it('behaves as resource dispatcher') { is_expected.to be_an ResourceCrudWorker }

  it_behaves_like 'a ResourceCrudWorker'

  describe '#process_action' do
    before { expect(resource).to receive(:update).with(resource_attrs) }

    it('updates resource') { expect { subject.send :process_action }.to_not raise_error }
  end
end
