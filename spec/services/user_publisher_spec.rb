require 'rails_helper'

RSpec.describe UserPublisher do
  subject { described_class }

  let(:user) { User.new }

  let(:token) { 'some_token_value' }

  let(:publish_args) do
    {
      notification: :registration,
      email: user.email,
      token: token,
      first_name: user.first_name,
      last_name: user.last_name
    }.to_json
  end

  describe '.publish' do
    before { allow(JWTWorker).to receive(:encode).and_return token }

    before do
      expect(PubSub).to receive(:instance) do
        double.tap { |redis| expect(redis).to receive(:publish).with('notifier.email', publish_args) }
      end
    end

    it('publishes all required registration mail attributes') { expect { subject.publish user }.to_not raise_error }
  end
end
