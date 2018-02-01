require 'rails_helper'

RSpec.describe ResourceDestroyer do
  let(:resource_attrs) { attributes_for :question }

  let(:resource) { instance_double Question, as_json: resource_attrs }

  subject { ResourceDestroyer.new resource }

  it('behaves as resource dispatcher') { is_expected.to be_an ResourceCrudWorker }

  describe '#call' do
    before { expect(resource).to receive(:destroy) }

    context 'when passed valid params' do
      before { be_broadcasted_succeeded resource }

      it('destroys and broadcasts resource') { expect { subject.call }.to_not raise_error }
    end

    context 'when passed invalid params' do
      let(:resource) { instance_double Question, errors: { errors: %w[error1 error2] } }

      before { be_broadcasted_failed resource }

      it('broadcasts resource errors') { expect { subject.call }.to_not raise_error }
    end
  end
end
