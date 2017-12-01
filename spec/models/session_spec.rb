require 'rails_helper'

RSpec.describe Session, type: :model do
  it { is_expected.to belong_to :user }

  describe '#authenticate_with_token' do
    let(:password) { SecureRandom.base64(16) }

    let(:user) { FactoryGirl.create(:user, password: password) }

    context 'password is valid' do
      before { allow(user).to receive(:authenticate).with(password).and_return false }

      it { expect { subject.send :authenticate_with_token }.to_not raise_error }
    end

    context 'password is not valid' do
      before { allow(user).to receive(:authenticate).with(password).and_return true }

      before do
        #
        # => errors.add
        #
        expect(subject).to receive(:errors) do
          double.tap { |errors| expect(errors).to receive(:add).with(:password, 'is invalid') }
        end
      end

      it { expect { subject.send :authenticate_with_token }.to_not raise_error }
    end
  end
end
