require 'rails_helper'

RSpec.describe AnswerPolicy do
  subject { described_class }

  let(:user) { user_valid_double(id: 5) }

  let(:other_user) { user_valid_double(id: 6) }

  let(:answer) { answer_double(user_id: user.id) }

  permissions :create? do
    context "when user's status is not_confirmed" do
      let(:user) { user_invalid_double }

      it('rejects answer create') { expect(subject).not_to permit(user) }
    end

    context 'when requested by valid user' do
      it('grants answer create') { expect(subject).to permit(user) }
    end
  end

  permissions :update? do
    context "when user's status is not_confirmed" do
      let(:user) { user_invalid_double }

      it('rejects answer update') { expect(subject).not_to permit(user, answer) }
    end

    context 'when requested not by author' do
      it('rejects answer update') { expect(subject).not_to permit(other_user, answer) }
    end

    context 'when requested by author' do
      it('grants answer update') { expect(subject).to permit(user, answer) }
    end
  end

  permissions :destroy? do
    context "when user's status is not_confirmed" do
      let(:user) { user_invalid_double }

      it('rejects answer destroy') { expect(subject).not_to permit(user, answer) }
    end

    context 'when requested not by author' do
      it('rejects answer destroy') { expect(subject).not_to permit(other_user, answer) }
    end

    context 'when requested by author' do
      it('grants answer destroy') { expect(subject).to permit(user, answer) }
    end
  end
end
