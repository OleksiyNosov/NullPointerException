require 'rails_helper'

RSpec.describe AnswerCreator do
  let(:user) { instance_double User, id: 5 }

  let(:question) { instance_double Question, id: 2 }

  let(:resource_attrs) { attributes_for :answer, question: question, user: user }

  let(:resource) { instance_double Answer, id: 3, as_json: resource_attrs, **resource_attrs }

  subject { AnswerCreator.new user, resource_attrs }

  it('behaves as resource dispatcher') { is_expected.to be_an ResourceCrudWorker }

  describe '#call' do
    before { allow(Question).to receive(:find).and_return question }

    before { allow(resource_attrs).to receive(:merge).with(user: user).and_return resource_attrs }

    before do
      allow(question).to receive(:answers) do
        double.tap { |answers| expect(answers).to receive(:create).with(resource_attrs).and_return resource }
      end
    end

    context 'when passed valid params' do
      before { be_broadcasted_succeeded resource }

      it('creates and broadcasts answer') { expect { subject.call }.to_not raise_error }
    end

    context 'when passed invalid params' do
      let(:resource) { instance_double Answer, errors: { errors: %w[error1 error2] } }

      before { be_broadcasted_failed resource }

      it('broadcasts question errors') { expect { subject.call }.to_not raise_error }
    end
  end
end
