require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  it { is_expected.to be_an ActionController::API }

  it { is_expected.to be_kind_of Authenticationalbe }

  it { is_expected.to be_kind_of Resourceable }
end
