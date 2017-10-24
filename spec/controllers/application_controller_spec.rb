require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  describe '#resource' do
    let(:resource) { double }

    before do
      #
      # => resource_class.find
      #
      expect(subject).to receive(:resource_class) do
        double.tap { |resource_class| expect(resource_class).to receive(:find).with(2).and_return resource }
      end

      its(:resource) { is_expected.to eq resource }
    end
  end
end
