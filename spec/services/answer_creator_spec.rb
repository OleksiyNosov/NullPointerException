require 'rails_helper'

RSpec.describe AnswerCreator do
  let(:user_double) { instance_double User, id: 5 }

  let(:question_double) { instance_double Question, id: 2 }

  let(:answer_attrs) { attributes_for(:answer, question: question_double, user: user_double) }

  let(:answer) { build(:answer, id: 3, **answer_attrs) }

  subject { AnswerCreator.new user_double, answer_attrs }

  it('behaves as resource dispatcher') { is_expected.to be_an ResourceCrudWorker }

  it('publishes resource') { is_expected.to be_kind_of Homie }

  describe '#process_action' do
    before { allow(Question).to receive(:find).and_return question_double }

    before { allow(answer_attrs).to receive(:merge).with(user: user_double).and_return answer_attrs }

    before do
      allow(question_double).to receive(:answers) do
        double.tap { |answers| expect(answers).to receive(:create).with(answer_attrs).and_return answer }
      end
    end

    it('creates answer') { expect { subject.send :process_action }.to_not raise_error }
  end

  describe '#call' do
    before { expect(subject).to receive(:process_action) }

    before { expect(subject).to receive(:broadcast_resource) }

    it('creates and broadcasts answer') { expect { subject.send :call }.to_not raise_error }
  end

  describe  '#broadcast_resource' do
    context 'when resource is valid' do
      before { allow(subject).to receive_message_chain(:resource, :valid?).and_return true }

      before { allow(subject).to receive(:serialized_resource).and_return answer }

      before { expect(subject).to receive(:broadcast).with(:succeeded, answer) }

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
    let(:serialized_resource) { AnswerSerializer.new(answer).as_json }

    before { allow(subject).to receive(:resource).and_return answer }

    it('resturns serialized answer') { expect(subject.send :serialized_resource).to eq serialized_resource }
  end
end
