require 'rails_helper'

RSpec.describe AuthTokenPolicy do
  subject { described_class }

  permissions :create? do
    it 'denies access if user status is :not_confirmed' do
      expect(subject).not_to permit(User.new, :AuthToken)
    end

    it 'grants access if user status is :confirmed' do
      expect(subject).to permit(User.new(status: :confirmed), :AuthToken)
    end
  end
end
