require 'rails_helper'

RSpec.describe Api::UsersController, type: :controller do
  it { is_expected.to be_an ApplicationController }

  it('authenticate and set user') { is_expected.to be_kind_of Authenticatable }

  it('handles exceptions') { is_expected.to be_kind_of Exceptionable }

  let(:attributes) { user.attributes }

  let(:invalid_attributes) { attributes.merge('password' => '123', 'password_confirmation' => '123', 'email' => '') }

  let(:errors) { { 'email' => ["can't be blank", 'is invalid'] }.to_json }

  let(:user) { create(:user, password: '123') }

  let(:user_values) { user.slice(:id, :email) }

  describe 'POST #create' do
    context 'when sent user attributes are valid' do
      let(:permitted_attributes) { ActionController::Parameters.new(email: user.email).permit! }

      let(:user_values) { user.slice(:email) }

      before { allow(User).to receive(:new).with(permitted_attributes).and_return user }

      before { post :create, params: { user: attributes }, format: :json }

      it('returns status 201') { expect(response).to have_http_status 201 }

      it('returns created user') { expect(response_values :email).to eq user_values }
    end

    context 'when request have invalid structure' do
      before { post :create, params: { invalid_key: attributes }, format: :json }

      it('returns status 400') { expect(response).to have_http_status 400 }
    end

    context 'when sent user attributes are not valid' do
      before { post :create, params: { user: invalid_attributes }, format: :json }

      it('returns status 422') { expect(response).to have_http_status 422 }

      it('returns errors') { expect(response.body).to eq errors }
    end
  end

  context 'with authentication' do
    before { sign_in user }

    describe 'GET #index' do
      let(:collection) { create_list(:user, 2).push(user) }

      let!(:collection_values) { collection.map { |element| element.slice(:id, :email) } }

      before { get :index, format: :json }

      it('returns status 200') { expect(response).to have_http_status 200 }

      it('returns collection of users') { expect(response_collection_values :id, :email).to have_same_elements collection_values }
    end

    describe 'GET #show' do
      context 'when requested user was found' do
        before { get :show, params: { id: user.id }, format: :json }

        it('returns status 200') { expect(response).to have_http_status 200 }

        it('returns user') { expect(response_values :id, :email).to eq user_values }
      end

      context 'when requested user did not found' do
        before { expect(User).to receive(:find).and_raise ActiveRecord::RecordNotFound }

        before { get :show, params: { id: -1 }, format: :json }

        it('returns status 404') { expect(response).to have_http_status 404 }
      end
    end

    describe 'PATCH $update' do
      describe 'when requested user was updated' do
        before { patch :update, params: { id: user.id, user: attributes }, format: :json }

        it('returns status 200') { expect(response).to have_http_status 200 }

        it('returns updated user') { expect(response_values :id, :email).to eq user_values }
      end

      context 'when request have invalid structure' do
        before { post :update, params: { id: user.id, invalid_key: attributes }, format: :json }

        it('returns status 400') { expect(response).to have_http_status 400 }
      end

      context 'when requested user did not found' do
        before { expect(User).to receive(:find).and_raise ActiveRecord::RecordNotFound }

        before { post :update, params: { id: -1, invalid_key: attributes }, format: :json }

        it('returns status 404') { expect(response).to have_http_status 404 }
      end

      describe 'when requested user was not updated' do
        before { patch :update, params: { id: user.id, user: invalid_attributes }, format: :json }

        it('returns status 422') { expect(response).to have_http_status 422 }

        it('returns errors') { expect(response.body).to eq errors }
      end
    end
  end
end
