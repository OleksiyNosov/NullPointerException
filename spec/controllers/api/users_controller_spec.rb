require 'rails_helper'

RSpec.describe Api::UsersController, type: :controller do
  it { is_expected.to be_an ApplicationController }

  let(:attributes) { attributes_for(:user) }

  let(:serialized_attributes) { attributes.stringify_keys }

  let(:user) { instance_double User, id: 5, as_json: attributes, **attributes }

  let(:resource_class) { User }

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

  describe 'POST #create' do
    before { expect(subject).to receive(:resource_class).and_return resource_class }

    before { expect(resource_class).to receive(:new).with(permit! attributes).and_return user }

    before { expect(user).to receive(:save) }

    context 'new user was created' do
      before { allow(user).to receive(:valid?).and_return true }

      before { post :create, params: { user: attributes }, format: :json }

      it('returns status 201') { expect(response).to have_http_status 201 }

      it('returns user profile') { expect(response_body).to eq serialized_attributes }
    end

    context 'new user was not created' do
      before { allow(user).to receive(:valid?).and_return false }

      before { expect(user).to receive(:errors).and_return :errors }

      before { post :create, params: { user: attributes }, format: :json }

      it('returns status 422') { expect(response).to have_http_status 422 }

      it('returns errors') { expect(response_body).to eq 'errors' }
    end
  end

  describe 'PATCH $update' do
    before { sign_in }

    before { expect(subject).to receive(:resource).and_return user }

    before { expect(user).to receive(:update).with(permit! attributes) }

    describe 'user profile was updated' do
      before { allow(user).to receive(:valid?).and_return true }

      before { patch :update, params: { id: user.id, user: attributes }, format: :json }

      it('returns status 200') { expect(response).to have_http_status 200 }

      it('returns updated profile') { expect(response_body).to eq serialized_attributes }
    end

    describe 'user profile was not updated' do
      before { allow(user).to receive(:valid?).and_return false }

      before { expect(user).to receive(:errors).and_return :errors }

      before { patch :update, params: { id: user.id, user: attributes }, format: :json }

      it('returns status 422') { expect(response).to have_http_status 422 }

      it('returns errors') { expect(response_body).to eq 'errors' }
    end
  end

  describe '#resource_class' do
    its(:resource_class) { is_expected.to eq User }
  end
end
