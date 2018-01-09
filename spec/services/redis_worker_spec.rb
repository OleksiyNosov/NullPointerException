require 'rails_helper'

RSpec.describe RedisWorker do
  subject { described_class }

  let(:redis_double) { double }

  describe '.instance' do
    before { subject.clear }

    before { expect(Redis).to receive(:new).with(host: 'localhost', port: 6379).and_return redis_double }

    it('returns instance of redis') { expect(subject.instance).to eq redis_double }
  end
end
