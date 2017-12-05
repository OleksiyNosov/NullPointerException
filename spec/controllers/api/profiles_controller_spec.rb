require 'rails_helper'

RSpec.describe Api::ProfilesController, type: :controller do
  it { is_expected.to be_an ApplicationController }

  let(:attributes) { attributes_for(:user) }

  let(:serialized_attributes) { attributes.stringify_keys }

  let(:resource) { instance_double User, id: 5, as_json: attributes, **attributes }

  let(:resource_class) { User }

  describe 'GET #show' do
    before { sign_in }

    before { expect(subject).to receive(:current_user).and_return resource }

    before { get :show, format: :json }

    it('returns status 200') { expect(response).to have_http_status 200 }

    it('returns user profile') { expect(response_body).to eq serialized_attributes }
  end

  describe '#resource' do
    before { allow(subject).to receive(:current_user).and_return resource }

    its(:resource) { is_expected.to eq resource }
  end
end
