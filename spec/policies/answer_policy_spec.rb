require 'rails_helper'

RSpec.describe AnswerPolicy do
  subject { described_class }

  let(:user) { build(:user, id: 5) }

  let(:other_user) { build(:user, id: 6) }

  let(:answer) { build(:answer, user: user) }

  permissions :create? do
    context 'when requested by invalid user' do
      let(:user) { build(:user, id: 5, status: :not_confirmed) }

      it('rejects answer create') { expect(subject).not_to permit(user, nil) }
    end

    context 'when requested by valid user' do
      it('grants answer create') { expect(subject).to permit(user, nil) }
    end
  end

  permissions :update? do
    context 'when requested by invalid user' do
      let(:user) { build(:user, id: 5, status: :not_confirmed) }

      it('rejects answer update') { expect(subject).not_to permit(user, answer) }
    end

    context 'when requested by some other user' do
      it('rejects answer update') { expect(subject).not_to permit(other_user, answer) }
    end

    context 'when requested by author' do
      it('grants answer update') { expect(subject).to permit(user, answer) }
    end
  end

  permissions :destroy? do
    context 'when requested by invalid user' do
      let(:user) { build(:user, id: 5, status: :not_confirmed) }

      it('rejects answer destroy') { expect(subject).not_to permit(user, answer) }
    end

    context 'when requested by some other user' do
      it('rejects answer destroy') { expect(subject).not_to permit(other_user, answer) }
    end

    context 'when requested by author' do
      it('grants answer destroy') { expect(subject).to permit(user, answer) }
    end
  end
end
