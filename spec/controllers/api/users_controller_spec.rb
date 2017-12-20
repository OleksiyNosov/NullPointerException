require 'rails_helper'

RSpec.describe Api::UsersController, type: :controller do
  it { is_expected.to be_an ApplicationController }

  it { is_expected.to be_kind_of Authenticatable }

  let(:attributes) { user.attributes }

  let(:invalid_attributes) { attributes.merge('password' => '123', 'password_confirmation' => '123', 'email' => '') }

  let(:errors) { { 'email' => ["can't be blank", 'is invalid'] }.to_json }

  let(:user) { FactoryBot.create(:user, password: '123') }

  let(:serialized_user) { UserSerializer.new(user) }

  let(:serialized_user_json) { serialized_user.to_json }

  describe 'POST #create' do
    context 'new user was created' do
      let(:permitted_attributes) { ActionController::Parameters.new(email: user.email).permit! }

      let(:serialized_attributes) { serialized_user.to_h.without(:id).stringify_keys }

      before { allow(User).to receive(:new).with(permitted_attributes).and_return user }

      before { post :create, params: { user: attributes }, format: :json }

      it('returns status 201') { expect(response).to have_http_status 201 }

      it('returns user') { expect(JSON.parse response.body).to include serialized_attributes }
    end

    context 'new user was not created' do
      before { post :create, params: { user: invalid_attributes }, format: :json }

      it('returns status 422') { expect(response).to have_http_status 422 }

      it('returns errors') { expect(response.body).to eq errors }
    end
  end

  context 'with authentication' do
    before { sign_in user }

    describe 'GET #index' do
      context 'users exist' do
        before { User.destroy_all }

        let(:collection) { FactoryBot.create_list(:user, 2) }

        let!(:collection_json) { collection.map { |element| UserSerializer.new(element) }.to_json }

        before { get :index, format: :json }

        it('returns status 200') { expect(response).to have_http_status 200 }

        it('returns users') { expect(response.body).to eq collection_json }
      end
    end

    describe 'GET #show' do
      context 'user exist' do
        before { get :show, params: { id: user.id }, format: :json }

        it('returns status 200') { expect(response).to have_http_status 200 }

        it('returns user') { expect(response.body).to eq serialized_user_json }
      end

      context 'user not exist' do
        before { get :show, params: { id: -1 }, format: :json }

        it('returns status 404') { expect(response).to have_http_status 404 }
      end
    end

    describe 'PATCH $update' do
      describe 'user was updated' do
        before { patch :update, params: { id: user.id, user: attributes }, format: :json }

        it('returns status 200') { expect(response).to have_http_status 200 }

        it('returns updated user') { expect(response.body).to eq serialized_user_json }
      end

      describe 'user was not updated' do
        before { patch :update, params: { id: user.id, user: invalid_attributes }, format: :json }

        it('returns status 422') { expect(response).to have_http_status 422 }

        it('returns errors') { expect(response.body).to eq errors }
      end
    end
  end
end
