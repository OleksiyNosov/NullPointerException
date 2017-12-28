require 'rails_helper'

RSpec.describe ResourceDestroyer do
  let(:resource) { instance_double Question, valid?: true }

  subject { ResourceDestroyer.new resource }

  it('behaves as resource dispatcher') { is_expected.to be_an ResourceCrudWorker }

  describe '#process_action' do
    before { expect(resource).to receive(:destroy) }

    it('destroy resource') { expect { subject.send :process_action }.to_not raise_error }
  end

  describe '#call' do
    before { expect(subject).to receive(:process_action) }

    before { expect(subject).to receive(:broadcast_resource) }

    it('destroy and broadcast resource') { expect { subject.call }.to_not raise_error }
  end

  describe  '#broadcast_resource' do
    context 'when resource is valid' do
      before { allow(subject).to receive_message_chain(:resource, :valid?).and_return true }

      before { allow(subject).to receive(:resource).and_return resource }

      before { expect(subject).to receive(:broadcast).with(:succeeded, resource) }

      it('broadcast resource') { expect { subject.send :broadcast_resource }.to_not raise_error }
    end

    context 'when resource is invalid' do
      let(:resource_errors) { double }

      before { allow(subject).to receive_message_chain(:resource, :valid?).and_return false }

      before { allow(subject).to receive_message_chain(:resource, :errors).and_return resource_errors }

      before { expect(subject).to receive(:broadcast).with(:failed, resource_errors) }

      it('broadcast resource errors') { expect { subject.send :broadcast_resource }.to_not raise_error }
    end
  end
end
