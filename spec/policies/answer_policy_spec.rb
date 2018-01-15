require 'rails_helper'

RSpec.describe AnswerPolicy do
  subject { described_class }

  let(:user) { instance_double User, id: 5 }

  let(:other_user) { instance_double User, id: 6 }

  let(:answer) { instance_double Answer, user_id: user.id }

  permissions :update? do
    context 'when requested by author' do
      it('grants answer update') { expect(subject).to permit(user, answer) }
    end

    context 'when requested by some other user' do
      it('denies answer update') { expect(subject).not_to permit(other_user, answer) }
    end
  end

  permissions :destroy? do
    context 'when requested by author' do
      it('grants answer destroy') { expect(subject).to permit(user, answer) }
    end

    context 'when requested by some other user' do
      it('denies answer destroy') { expect(subject).not_to permit(other_user, answer) }
    end
  end
end
