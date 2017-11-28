require 'rails_helper'

RSpec.describe ResourceDestroyer do
  let(:resource) { instance_double Question }

  subject { ResourceDestroyer.new resource }

  it { is_expected.to be_an ResourceCrudWorker }

  describe 'process_action' do
    before { allow(resource).to receive(:destroy).and_return resource }

    its(:process_action) { is_expected.to eq resource }
  end

  describe 'call' do
    before { expect(subject).to receive(:process_action) }

    before { expect(subject).to receive(:broadcast_resource) }

    it { expect { subject.call }.to_not raise_error }
  end
end
