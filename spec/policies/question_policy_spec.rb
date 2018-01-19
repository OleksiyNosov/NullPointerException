require 'rails_helper'

RSpec.describe QuestionPolicy do
  subject { described_class }

  let(:user) { instance_double User, id: 5 }

  let(:other_user) { instance_double User, id: 6 }

  let(:question) { instance_double Question, user_id: user.id }

  permissions :update? do
    context 'when requested by author' do
      it('grants question update') { expect(subject).to permit(user, question) }
    end

    context 'when requested by some other user' do
      it('rejects question update') { expect(subject).not_to permit(other_user, question) }
    end
  end

  permissions :destroy? do
    context 'when requested by author' do
      it('grants question destroy') { expect(subject).to permit(user, question) }
    end

    context 'when requested by some other user' do
      it('rejects question destroy') { expect(subject).not_to permit(other_user, question) }
    end
  end
end
