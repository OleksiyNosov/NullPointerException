require 'rails_helper'

RSpec.describe Api::UsersController, type: :controller do
  it { is_expected.to be_an ApplicationController }

  let(:user) { instance_double User }

  let(:user_attrs) { attributes_for(:user) }

  let(:user_double) { instance_double(User, id: 5, as_json: user_attrs, **user_attrs) }

  let(:user_errors) { { attribute_name: %w[error1 error2] } }

  describe 'GET #show' do
    context 'when not authenticated' do
      before { get :show, params: { id: user_double.id }, format: :json }

      it('returns status 401') { expect(response).to have_http_status 401 }
    end

    context 'with authentication' do
      before { sign_in user }

      context 'when requested user found' do
        before { allow(subject).to receive(:resource).and_return user_double }

        before { get :show, params: { id: user_double.id }, format: :json }

        it('returns status 200') { expect(response).to have_http_status 200 }

        it('returns user') { expect(response.body).to eq user_double.to_json }
      end

      context 'when requested user not found' do
        before { expect(subject).to receive(:resource).and_raise ActiveRecord::RecordNotFound }

        before { get :show, params: { id: user_double.id }, format: :json }

        it('returns status 404') { expect(response).to have_http_status 404 }
      end
    end
  end

  describe 'POST #create' do
    let(:creator) { ResourceCreator.new User, user_attrs }

    context 'when request do not have requied keys' do
      before { post :create, params: { invalid_key: user_attrs }, format: :json }

      it('returns status 400') { expect(response).to have_http_status 400 }
    end

    context 'when sent user attributes are valid' do
      before { allow(ResourceCreator).to receive(:new).and_return creator }

      before { expect(creator).to receive(:on).twice.and_call_original }

      before { broadcast_succeeded creator, user_double }

      before { post :create, params: { user: user_attrs }, format: :json }

      it('returns status 201') { expect(response).to have_http_status 201 }

      it('returns created user') { expect(response.body).to eq user_double.to_json }
    end

    context 'when sent user attributes are not valid' do
      before { allow(ResourceCreator).to receive(:new).and_return creator }

      before { expect(creator).to receive(:on).twice.and_call_original }

      before { broadcast_failed creator, user_errors }

      before { post :create, params: { user: user_attrs }, format: :json }

      it('returns status 422') { expect(response).to have_http_status 422 }

      it('returns errors') { expect(response.body).to eq user_errors.to_json }
    end
  end

  describe 'PATCH #update' do
    context 'when not authenticated' do
      before { patch :update, params: { id: user_double.id, user: user_attrs }, format: :json }

      it('returns status 401') { expect(response).to have_http_status 401 }
    end

    context 'with authentication' do
      let(:updator) { ResourceUpdator.new user_double, user_attrs }

      before { sign_in user }

      context 'when request do not have requied keys' do
        before { expect(subject).to receive(:resource) }

        before { patch :update, params: { id: user_double.id }, format: :json }

        it('returns status 400') { expect(response).to have_http_status 400 }
      end

      context 'when requested user not found' do
        before { expect(subject).to receive(:resource).and_raise ActiveRecord::RecordNotFound }

        before { patch :update, params: { id: user_double.id, user: user_attrs }, format: :json }

        it('returns status 404') { expect(response).to have_http_status 404 }
      end

      context 'when sent user attributes are valid' do
        before { allow(subject).to receive(:resource).and_return user_double }

        before { allow(ResourceUpdator).to receive(:new).and_return updator }

        before { expect(updator).to receive(:on).twice.and_call_original }

        before { broadcast_succeeded updator, user_double }

        before { patch :update, params: { id: user_double.id, user: user_attrs }, format: :json }

        it('returns status 200') { expect(response).to have_http_status 200 }

        it('returns updated user') { expect(response.body).to eq user_double.to_json }
      end

      context 'when sent user attributes are not valid' do
        before { allow(subject).to receive(:resource).and_return user_double }

        before { allow(ResourceUpdator).to receive(:new).and_return updator }

        before { expect(updator).to receive(:on).twice.and_call_original }

        before { broadcast_failed updator, user_errors }

        before { patch :update, params: { id: user_double.id, user: user_attrs }, format: :json }

        it('returns status 422') { expect(response).to have_http_status 422 }

        it('returns updated user') { expect(response.body).to eq user_errors.to_json }
      end
    end
  end

  describe '#resource' do
    before { get :show, params: { id: 5 }, format: :json }

    before { allow(User).to receive(:find).with('5').and_return user_double }

    it('returns user') { expect(subject.send :resource).to eq user_double }
  end
end
