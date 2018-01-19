require 'rails_helper'

RSpec.describe UserPolicy do
  subject { described_class }

  let(:user) { User.new id: 5 }

  permissions :update? do
    context 'when requested by same user' do
      it('grants update of user') { expect(subject).to permit(user, user) }
    end

    context 'whed requested by some other user' do
      let(:other_user) { instance_double User, id: 7 }

      it('rejects update of user') { expect(subject).not_to permit(user, other_user) }
    end
  end

  permissions :confirm? do
    context "when user's status is not_confirmed" do
      it('grants user confirmation') { expect(subject).to permit(user, User) }
    end

    context "when user's status is already confirmed" do
      let(:user) { User.new id: 5, status: :confirmed }

      it('rejects user confirmation') { expect(subject).not_to permit(user, User) }
    end
  end
end
