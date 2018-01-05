require 'rails_helper'

RSpec.describe UserPolicy do
  subject { described_class }

  let(:user) { User.new(id: 5) }

  let(:other_user) { User.new(id: 7) }

  permissions :update? do
    it 'denies access if not the same user' do
      expect(subject).not_to permit(user, other_user)
    end

    it 'grants access if same user' do
      expect(subject).to permit(user, user)
    end
  end
end
