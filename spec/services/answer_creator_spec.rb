require 'rails_helper'

RSpec.describe AnswerCreator do
  let(:user_double) { instance_double User, id: 5 }

  let(:question_double) { instance_double Question, id: 2 }

  let(:answer_attrs) { attributes_for(:answer) }

  let(:answer_double) { instance_double Answer, id: 3, question: question_double, user: user_double }

  subject { AnswerCreator.new question_double, user_double, answer_attrs }

  describe '#process_action' do
    before { allow(answer_attrs).to receive(:merge).with(user_id: user_double.id).and_return answer_attrs }

    before do
      allow(question_double).to receive(:answers) do
        double.tap { |answers| expect(answers).to receive(:create).with(answer_attrs).and_return answer_double }
      end
    end

    it('create answer') { expect { subject.send :process_action }.to_not raise_error }
  end

  describe '#call' do
    before { expect(subject).to receive(:process_action) }

    before { expect(subject).to receive(:broadcast_resource) }

    it('create and broadcast answer') { expect { subject.send :call }.to_not raise_error }
  end
end
