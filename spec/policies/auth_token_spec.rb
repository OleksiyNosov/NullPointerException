require 'rails_helper'

RSpec.describe AuthTokenPolicy do
  subject { described_class }

  permissions :create? do
    context "when user's status is not_confirmed" do
      it('rejects token creation') { expect(subject).to permit(User.new(status: :confirmed), :AuthToken) }
    end

    context "when user's status is confirmed" do
      it('grants token creation') { expect(subject).not_to permit(User.new, :AuthToken) }
    end
  end
end
