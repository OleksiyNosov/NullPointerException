require 'rails_helper'

RSpec.describe Api::UsersController, type: :controller do
  it { is_expected.to be_an ApplicationController  }

  let(:attributes) { attributes_for(:user) }

  let(:serialized_attributes) { attributes.stringify_keys }

  let(:user) { instance_double(User, id: 5, as_json: attributes, **attributes) }

  describe 'GET #index' do
    before { sign_in }

    context 'users exist' do
      before { expect(User).to receive(:all).and_return [user] }

      before { get :index, format: :json }

      it('returns status 200') { expect(response).to have_http_status 200 }

      it('returns users') { expect(response_body).to eq [serialized_attributes] }
    end

    context 'user not exist' do
      before { expect(subject).to receive(:resource).and_raise ActiveRecord::RecordNotFound }

      before { get :show, params: { id: user.id }, format: :json }

      it('returns status 404') { expect(response).to have_http_status 404 }
    end
  end

  describe 'GET #show' do
    before { sign_in }

    context 'user exist' do
      before { expect(subject).to receive(:resource).and_return user }

      before { get :show, params: { id: user.id }, format: :json }

      it('returns status 200') { expect(response).to have_http_status 200 }

      it('returns user') { expect(response_body).to eq serialized_attributes }
    end

    context 'user not exist' do
      before { expect(subject).to receive(:resource).and_raise ActiveRecord::RecordNotFound }

      before { get :show, params: { id: user.id }, format: :json }

      it('returns status 404') { expect(response).to have_http_status 404 }
    end
  end
end
