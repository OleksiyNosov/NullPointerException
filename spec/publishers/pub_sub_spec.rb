require 'rails_helper'

RSpec.describe PubSub do
  subject { described_class }

  let(:redis) { Redis.current }

  describe '.instance' do
    before { allow(Redis).to receive(:current).and_return redis }

    it('returns instance of redis') { expect(subject.client).to eq redis }
  end
end
