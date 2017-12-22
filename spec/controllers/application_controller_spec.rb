require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  it('inherits from ActionController::API') { is_expected.to be_an ActionController::API }

  it('authenticate and set user') { is_expected.to be_kind_of Authenticatable }

  it('handles exceptions') { is_expected.to be_kind_of Exceptionable }
end
