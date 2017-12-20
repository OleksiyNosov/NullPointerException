require 'rails_helper'

RSpec.describe Api::ProfilesController, type: :controller do
  it { is_expected.to be_an ApplicationController }

  it { is_expected.to be_kind_of Authenticatable }

  it { is_expected.to be_kind_of Exceptionable }

  let(:attributes) { attributes_for(:user) }

  let(:serialized_attributes) { attributes.stringify_keys }

  let(:user) { instance_double User, id: 5, as_json: attributes, **attributes }

  describe 'GET #show' do
    before { sign_in user }

    before { allow(subject).to receive(:current_user).and_return user }

    before { get :show, format: :json }

    it('returns status 200') { expect(response).to have_http_status 200 }

    it('returns user profile') { expect(response.body).to eq user.to_json }
  end

  describe '#resource' do
    before { allow(subject).to receive(:current_user).and_return user }

    it('returns current user profile') { expect(subject.send :resource).to eq user }
  end
end
