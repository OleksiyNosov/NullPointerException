require 'rails_helper'

RSpec.describe Api::ProfilesController, type: :controller do
  it('inherits from ApplicationController') { is_expected.to be_an ApplicationController }

  it('authenticate and set user') { is_expected.to be_kind_of Authenticatable }

  it('handles exceptions') { is_expected.to be_kind_of Exceptionable }

  let(:user) { create(:user) }

  let(:profile_values) { user.slice(:id, :email) }

  describe 'GET #show' do
    before { sign_in user }

    before { get :show, format: :json }

    it('returns status 200') { expect(response).to have_http_status 200 }

    it('returns user profile') { expect(response_values :id, :email).to eq profile_values }
  end
end
