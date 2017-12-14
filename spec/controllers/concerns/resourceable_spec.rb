require 'rails_helper'

RSpec.describe Resourceable do
  before do
    class FakeClassController < ActionController::API
      include Resourceable
    end
  end

  subject { FakeClassController.new }

  before { class FakeClass end }

  describe '#resource_class_name' do
    it('returns resource class name') { expect(subject.send :resource_class_name).to eq 'FakeClass' }
  end

  describe 'resource_class' do
    it('returns resource class') { expect(subject.send :resource_class).to eq FakeClass }
  end

  describe '#resource' do
    let(:id) { 17 }

    let(:resource) { FakeClass.new }

    before do
      allow(subject).to receive(:params) do
        double.tap { |params| allow(params).to receive(:[]).with(:id).and_return id }
      end
    end

    before do
      allow(subject).to receive(:resource_class) do
        double.tap { |resource_class| allow(resource_class).to receive(:find).with(id).and_return resource }
      end
    end

    it('returns resource') { expect(subject.send :resource).to eq resource }
  end

  describe '#collection' do
    let(:collection) { double }

    before do
      allow(subject).to receive(:resource_class) do
        double.tap { |resource_class| allow(resource_class).to receive(:all).and_return collection }
      end
    end

    it('returns collection') { expect(subject.send :collection).to eq collection }
  end
end
