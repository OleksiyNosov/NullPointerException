require 'rails_helper'

RSpec.describe PubSub do
  subject { described_class }

  let(:redis_double) { double }

  describe '.instance' do
    before { allow(Redis).to receive(:current).and_return redis_double }

    it('returns instance of redis') { expect(subject.instance).to eq redis_double }
  end
end
