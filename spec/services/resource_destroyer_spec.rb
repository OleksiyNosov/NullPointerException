require 'rails_helper'

RSpec.describe ResourceDestroyer do
  let(:resource) { instance_double Question }

  subject { ResourceDestroyer.new resource }

  it { is_expected.to be_an ResourceCrudWorker }

  describe 'assemble_resource' do
    before { allow(resource).to receive(:destroy).and_return resource }

    its(:assemble_resource) { is_expected.to eq resource }
  end

  describe 'call' do
    before { expect(subject).to receive(:assemble_resource) }

    before { expect(subject).to receive(:broadcast_resource) }

    it { expect { subject.call }.to_not raise_error }
  end
end
