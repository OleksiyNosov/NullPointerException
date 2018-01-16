require 'rails_helper'

RSpec.describe UserPublisher do
  subject { described_class }

  let(:user_attrs) { { user_hash: :with_attributes } }

  let(:user_attrs_json) { user_attrs.to_json }

  describe '.publish' do
    before { expect(user_attrs).to receive(:to_json).and_return user_attrs_json }

    before do
      expect(PubSub).to receive(:instance) do
        double.tap do |instance|
          expect(instance).to receive(:publish).with('notifier.email', user_attrs_json)
        end
      end
    end

    it 'publishes all required registration mail attributes' do
      expect { subject.publish user_attrs }.to_not raise_error
    end
  end
end
