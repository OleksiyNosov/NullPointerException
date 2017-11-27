require 'rails_helper'

RSpec.describe ResourceCreator do
  let(:resource_attributes) { attributes_for(:question) }

  let(:resource_class) { Question }

  let(:resource) { instance_double(resource_class, **resource_attributes) }

  subject { ResourceCreator.new resource_class, resource_attributes }

  it { is_expected.to be_an ResourceCrudWorker }

  describe '#initialize' do
    before { subject.instance_variable_set(:@resource_class, resource_class) }

    before { subject.instance_variable_set(:@params, resource_attributes) }

    it { expect { ResourceCreator.new resource_class, resource_attributes }.to_not raise_error }
  end

  describe '#assemble_resource' do
    before { expect(resource_class).to receive(:new).with(resource_attributes).and_return resource }

    before { expect(resource).to receive(:save) }

    it { expect { subject.send(:assemble_resource) }.to_not raise_error }
  end

  describe '#call' do
    before { expect(subject).to receive(:assemble_resource) }

    before { expect(subject).to receive(:broadcast_resource) }

    it { expect { subject.send(:call) }.to_not raise_error }
  end
end
