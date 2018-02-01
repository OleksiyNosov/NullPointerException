require 'rails_helper'

RSpec.describe QuestionPolicy do
  subject { described_class }

  let(:user) { user_valid_double(id: 5) }

  let(:other_user) { user_valid_double(id: 6) }

  let(:question) { question_double(id: 7, user_id: user.id) }

  permissions :create? do
    context "when user's status is not_confirmed" do
      let(:user) { user_invalid_double }

      it('rejects question create') { expect(subject).not_to permit(user, nil) }
    end

    context 'when requested by valid user' do
      it('grants question create') { expect(subject).to permit(user, nil) }
    end
  end

  permissions :update? do
    context "when user's status is not_confirmed" do
      let(:user) { user_invalid_double }

      it('rejects question destroy') { expect(subject).not_to permit(user, question) }
    end

    context 'when requested not by author' do
      it('rejects question update') { expect(subject).not_to permit(other_user, question) }
    end

    context 'when requested by author' do
      it('grants question update') { expect(subject).to permit(user, question) }
    end
  end

  permissions :destroy? do
    context "when user's status is not_confirmed" do
      let(:user) { user_invalid_double }

      it('rejects question destroy') { expect(subject).not_to permit(user, question) }
    end

    context 'when requested not by author' do
      it('rejects question destroy') { expect(subject).not_to permit(other_user, question) }
    end

    context 'when requested by author' do
      it('grants question destroy') { expect(subject).to permit(user, question) }
    end
  end
end
