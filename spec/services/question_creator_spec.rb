require 'rails_helper'

RSpec.describe QuestionCreator do
  let(:user) { instance_double User, id: 5 }

  let(:resource_attrs) { attributes_for :question }

  let(:resource) { instance_double Question, id: 5, as_json: resource_attrs, **resource_attrs }

  subject { QuestionCreator.new user, resource_attrs }

  it('behaves as resource dispatcher') { is_expected.to be_an ResourceCrudWorker }

  it_behaves_like 'a ResourceCrudWorker'

  describe '#process_action' do
    before { allow(resource_attrs).to receive(:merge).with(user: user).and_return resource_attrs }

    before { expect(Question).to receive(:create).with(resource_attrs) }

    it('creates resource') { expect { subject.send :process_action }.to_not raise_error }
  end
end
