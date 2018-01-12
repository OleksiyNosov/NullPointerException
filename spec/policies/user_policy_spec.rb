require 'rails_helper'

RSpec.describe UserPolicy do
  subject { described_class }

  let(:user) { instance_double User, id: 5, confirmed?: true }

  permissions :update? do
    context 'when requested bu same user' do
      it('grants access') { expect(subject).to permit(user, user) }
    end

    context 'whed requested by some other user' do
      let(:other_user) { instance_double User, id: 7 }

      it('denies access') { expect(subject).not_to permit(user, other_user) }
    end
  end

  permissions :confirm? do
    context 'when user is not_confirmed' do
      let(:user) { instance_double User, id: 5, confirmed?: false }

      it('grants access') { expect(subject).to permit(user, User) }
    end

    context 'when user is already confirmed' do
      it('denies access') { expect(subject).not_to permit(user, User) }
    end
  end
end
