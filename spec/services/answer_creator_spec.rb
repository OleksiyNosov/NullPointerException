require 'rails_helper'

RSpec.describe AnswerCreator do
  let(:user) { instance_double User, id: 5 }

  let(:question) { instance_double Question, id: 2 }

  let(:resource_attrs) { attributes_for :answer, question: question, user: user }

  let(:resource) { instance_double Answer, id: 3, as_json: resource_attrs, **resource_attrs }

  subject { AnswerCreator.new user, resource_attrs }

  it('behaves as resource dispatcher') { is_expected.to be_an ResourceCrudWorker }

  it_behaves_like 'a ResourceCrudWorker'

  describe '#process_action' do
    before { allow(Question).to receive(:find).and_return question }

    before { allow(resource_attrs).to receive(:merge).with(user: user).and_return resource_attrs }

    before do
      allow(question).to receive(:answers) do
        double.tap { |answers| expect(answers).to receive(:create).with(resource_attrs).and_return resource }
      end
    end

    it('creates answer') { expect { subject.send :process_action }.to_not raise_error }
  end
end
