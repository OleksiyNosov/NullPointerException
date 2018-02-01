require 'rails_helper'

RSpec.describe AuthTokenPolicy do
  subject { described_class }

  let(:user) { user_valid_double }

  permissions :create? do
    context "when user's status is not_confirmed" do
      let(:user) { user_invalid_double }

      it 'rejects token creation' do
        expect(subject).not_to permit(user, :auth_token)
      end
    end

    context "when user's status is confirmed" do
      it('grants token creation') { expect(subject).to permit(user, :auth_token) }
    end
  end
end
