require 'rails_helper'

RSpec.describe UserPolicy do
  subject { described_class }

  let(:user) { build(:user, id: 5) }

  let(:other_user) { instance_double User, id: 7 }

  permissions :show? do
    context "when user's status is not_confirmed" do
      let(:user) { build(:user, status: :not_confirmed) }

      it('rejects to show requested user') { expect(subject).not_to permit(user, other_user) }
    end

    context 'when user is valid' do
      it('allow to show requested user') { expect(subject).to permit(user, other_user) }
    end
  end

  permissions :update? do
    context "when user's status is not_confirmed" do
      let(:user) { build(:user, status: :not_confirmed) }

      it('rejects update of user') { expect(subject).not_to permit(user, user) }
    end

    context 'whed requested by some other user' do
      it('rejects update of user') { expect(subject).not_to permit(user, other_user) }
    end

    context 'when requested by same user' do
      it('grants update of user') { expect(subject).to permit(user, user) }
    end
  end

  permissions :confirm? do
    context "when user's status is already confirmed" do
      it('rejects user confirmation') { expect(subject).not_to permit(user, User) }
    end

    context "when user's status is not_confirmed" do
      let(:user) { build(:user, status: :not_confirmed) }

      it('grants user confirmation') { expect(subject).to permit(user, User) }
    end
  end
end
