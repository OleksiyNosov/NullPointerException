require 'rails_helper'

RSpec.describe User, type: :model do
  let(:invalid_mails) { %w[test test@test test@test. test@.com @a.com ..@..com] }

  it { is_expected.to be_an ApplicationRecord }

  it { is_expected.to validate_presence_of :first_name }

  it { is_expected.to validate_presence_of :last_name }

  it { is_expected.to validate_presence_of :email }

  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }

  it { is_expected.to validate_length_of(:email).is_at_most(255) }

  it { is_expected.not_to allow_values(invalid_mails).for(:email) }

  it { is_expected.to allow_value('test@example.com').for(:email) }
end
