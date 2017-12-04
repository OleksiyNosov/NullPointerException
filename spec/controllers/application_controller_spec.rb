require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  describe '#resource' do
    let(:resource) { double }

    let(:id) { 1 }

    let(:resource_class) { double }

    before do
      #
      # => params[:id]
      #
      expect(subject).to receive(:params) do
        double.tap { |params| expect(params).to receive(:[]).with(:id).and_return id }
      end
    end

    before do
      #
      # => resource_class.find
      #
      expect(subject).to receive(:resource_class) do
        double.tap { |resource_class| expect(resource_class).to receive(:find).with(id).and_return resource }
      end
    end

    its(:resource) { is_expected.to eq resource }
  end

  describe '#resource_class' do
    before { allow(controller).to receive_message_chain(:class, :controller_name).and_return 'fake_classes' }

    before { class FakeClass end }

    its(:resource_class) { is_expected.to eq FakeClass }
  end
end
