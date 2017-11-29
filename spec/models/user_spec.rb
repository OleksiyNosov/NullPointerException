require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to be_an ApplicationRecord }

  it { is_expected.to validate_presence_of :email }

  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }

  it { is_expected.not_to allow_value('test').for(:email) }

  it { is_expected.to allow_value('test@example.com').for(:email) }
end