require 'rails_helper'

RSpec.describe ProfilePolicy do
  subject { described_class }

  let(:user) { user_valid_double }

  permissions :show? do
    context "when user's status is not_confirmed" do
      let(:user) { user_invalid_double }

      it('rejects access to profile') { expect(subject).not_to permit(user, user) }
    end

    context 'when user is valid' do
      it('grants access to profile') { expect(subject).to permit(user, user) }
    end
  end
end
