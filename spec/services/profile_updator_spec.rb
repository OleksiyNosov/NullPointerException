require 'rails_helper'

RSpec.describe ProfileUpdator do
  let(:resource_attributes) { attributes_for(:user) }

  let(:resource) { instance_double User }

  subject { ProfileUpdator.new resource, resource_attributes }

  describe '#process_action' do
    before { expect(resource).to receive(:update).with(resource_attributes) }

    before do
      #
      # => resource.sessions.destroy_all
      #
      expect(resource).to receive(:sessions) do
        double.tap { |sessions| expect(sessions).to receive(:destroy_all) }
      end
    end

    it { expect { subject.send :process_action }.to_not raise_error }
  end
end
