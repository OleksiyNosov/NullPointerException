shared_examples 'a ResourceCrudWorker' do
  it('publishes resource') { is_expected.to be_kind_of Homie }

  describe '#call' do
    before { expect(subject).to receive(:process_action) }

    before { expect(subject).to receive(:broadcast_resource) }

    it('creates and broadcasts answer') { expect { subject.send :call }.to_not raise_error }
  end

  describe  '#broadcast_resource' do
    context 'when resource is valid' do
      before { allow(subject).to receive_message_chain(:resource, :valid?).and_return true }

      before { allow(subject).to receive(:serialized_resource).and_return resource }

      before { expect(subject).to receive(:broadcast).with(:succeeded, resource) }

      it('broadcasts serialized resource') { expect { subject.send :broadcast_resource }.to_not raise_error }
    end

    context 'when resource is invalid' do
      let(:resource_errors) { double }

      before { allow(subject).to receive_message_chain(:resource, :valid?).and_return false }

      before { allow(subject).to receive_message_chain(:resource, :errors).and_return resource_errors }

      before { expect(subject).to receive(:broadcast).with(:failed, resource_errors) }

      it('broadcasts resource errors') { expect { subject.send :broadcast_resource }.to_not raise_error }
    end
  end

  describe '#serialized_resource' do
    let(:serialized_resource) { ActiveModelSerializers::SerializableResource.new(resource).as_json }

    before { allow(subject).to receive(:resource).and_return resource }

    it('resturns serialized answer') { expect(subject.send :serialized_resource).to eq serialized_resource }
  end
end
