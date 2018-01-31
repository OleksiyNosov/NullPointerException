require 'rails_helper'

RSpec.describe ResourceDestroyer do
  let(:resource_attrs) { attributes_for :question }

  let(:resource) { instance_double Question, as_json: resource_attrs }

  subject { ResourceDestroyer.new resource }

  it('behaves as resource dispatcher') { is_expected.to be_an ResourceCrudWorker }

  it_behaves_like 'a ResourceCrudWorker'

  describe '#process_action' do
    before { expect(resource).to receive(:destroy) }

    it('destroys resource') { expect { subject.send :process_action }.to_not raise_error }
  end
end
