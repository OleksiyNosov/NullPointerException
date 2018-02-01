require 'rails_helper'

RSpec.describe QuestionCreator do
  let(:user) { instance_double User, id: 5 }

  let(:resource_attrs) { attributes_for :question }

  let(:resource) { instance_double Question, id: 5, as_json: resource_attrs, **resource_attrs }

  subject { QuestionCreator.new user, resource_attrs }

  it('behaves as resource dispatcher') { is_expected.to be_an ResourceCrudWorker }

  describe '#call' do
    before { allow(resource_attrs).to receive(:merge).with(user: user).and_return resource_attrs }

    before { allow(Question).to receive(:create).with(resource_attrs).and_return resource }

    context 'when passed valid params' do
      before { be_broadcasted_succeeded resource }

      it('creates and broadcasts question') { expect { subject.call }.to_not raise_error }
    end

    context 'when passed invalid params' do
      let(:resource) { instance_double Question, errors: { errors: %w[error1 error2] } }

      before { be_broadcasted_failed resource }

      it('broadcasts question errors') { expect { subject.call }.to_not raise_error }
    end
  end
end
