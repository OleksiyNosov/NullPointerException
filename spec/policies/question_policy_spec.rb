require 'rails_helper'

RSpec.describe QuestionPolicy do
  subject { described_class }

  let(:user) { build(:user, id: 5) }

  let(:other_user) { build(:user, id: 6) }

  let(:question) { build(:question, id: 7, user: user) }

  permissions :create? do
    context "when user's status is not_confirmed" do
      let(:user) { build(:user, status: :not_confirmed) }

      it('rejects question create') { expect(subject).not_to permit(user, nil) }
    end

    context 'when requested by valid user' do
      it('grants question create') { expect(subject).to permit(user, nil) }
    end
  end

  permissions :update? do
    context "when user's status is not_confirmed" do
      let(:user) { build(:user, status: :not_confirmed) }

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
      let(:user) { build(:user, status: :not_confirmed) }

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
