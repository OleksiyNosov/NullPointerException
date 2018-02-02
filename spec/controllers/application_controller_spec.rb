require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  it { is_expected.to be_an ActionController::API }

  it('authenticate and set user') { is_expected.to be_kind_of Authenticatable }

  it('authorize current user') { is_expected.to be_kind_of Pundit }

  it('handles exceptions') { is_expected.to be_kind_of ErrorHandable }
end
