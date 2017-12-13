require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  it { is_expected.to be_kind_of Authenticatable }

  it { is_expected.to be_kind_of Resourceable }

  describe '#resource' do
    let(:resource) { double }

    let(:id) { 1 }

    let(:resource_class) { double }

    before { allow(subject).to receive_message_chain(:params, :[]).with(:id).and_return id }

    before { allow(subject).to receive_message_chain(:resource_class, :find).with(id).and_return resource }

    its(:resource) { is_expected.to eq resource }
  end

  describe '#resource_class' do
    before { allow(controller).to receive_message_chain(:class, :controller_name).and_return 'fake_classes' }

    before { class FakeClass end }

    its(:resource_class) { is_expected.to eq FakeClass }
  end
end
