require 'rails_helper'

RSpec.describe Api::ProfilesController, type: :controller do
  it { is_expected.to be_an ApplicationController }

  it('authenticate and set user') { is_expected.to be_kind_of Authenticatable }

  it('handles exceptions') { is_expected.to be_kind_of Exceptionable }

  let(:user_attrs) { attributes_for(:user) }

  let(:user_double) { instance_double(User, id: 5, as_json: user_attrs, **user_attrs) }

  let(:user_errors) { { 'email' => ["can't be blank"] } }

  describe 'GET #show' do
    context 'when not authenticated' do
      before { get :show, format: :json }

      it('returns status 401') { expect(response).to have_http_status 401 }
    end

    context 'when authenticated' do
      before { sign_in user_double }

      before { allow(subject).to receive(:resource).and_return user_double }

      before { get :show, format: :json }

      it('returns status 200') { expect(response).to have_http_status 200 }

      it('returns user profile') { expect(response.body).to eq user_double.to_json }
    end
  end
end
