require 'rails_helper'

RSpec.describe ProfilePolicy do
  subject { described_class }

  let(:user) { build(:user) }

  permissions :show? do
    context "when user's status is not_confirmed" do
      let(:user) { build(:user, status: :not_confirmed) }

      it('rejects access to profile') { expect(subject).not_to permit(user, user) }
    end

    context 'when user is valid' do
      it('grants access to profile') { expect(subject).to permit(user, user) }
    end
  end
end
