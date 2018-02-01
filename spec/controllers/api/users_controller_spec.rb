require 'rails_helper'

RSpec.describe Api::UsersController, type: :controller do
  it { is_expected.to be_an ApplicationController }

  let(:user_attrs) { attributes_for(:user) }

  let(:user) { instance_double(User, id: 5, as_json: user_attrs, **user_attrs) }

  let(:user_errors) { { attribute_name: %w[error1 error2] } }

  describe 'GET #show' do
    context 'when not authenticated' do
      before { get :show, params: { id: user.id }, format: :json }

      it('returns status 401') { expect(response).to have_http_status 401 }
    end

    context 'with authentication' do
      before { sign_in user }

      context 'when requested user not found' do
        before { expect(subject).to receive(:resource).and_raise ActiveRecord::RecordNotFound }

        before { get :show, params: { id: user.id }, format: :json }

        it('returns status 404') { expect(response).to have_http_status 404 }
      end

      context 'when not authorized' do
        before { allow(subject).to receive(:resource).and_return user }

        before { expect(subject).to receive(:authorize).and_raise Pundit::NotAuthorizedError }

        before { get :show, params: { id: user.id }, format: :json }

        it('returns status 403') { expect(response).to have_http_status 403 }
      end

      context 'with authorization' do
        before { allow(subject).to receive(:resource).and_return user }

        before { allow(subject).to receive(:authorize).and_return true }

        context 'when requested user found' do
          before { get :show, params: { id: user.id }, format: :json }

          it('returns status 200') { expect(response).to have_http_status 200 }

          it('returns user') { expect(response.body).to eq user.to_json }
        end
      end
    end
  end

  describe 'POST #create' do
    let(:creator) { UserCreator.new user_attrs }

    context 'when request do not have requied keys' do
      before { post :create, params: { invalid_key: user_attrs }, format: :json }

      it('returns status 400') { expect(response).to have_http_status 400 }
    end

    context 'when sent user attributes are not valid' do
      before { allow(UserCreator).to receive(:new).and_return creator }

      before { expect(creator).to receive(:on).twice.and_call_original }

      before { broadcast_failed creator, user_errors }

      before { post :create, params: { user: user_attrs }, format: :json }

      it('returns status 422') { expect(response).to have_http_status 422 }

      it('returns errors') { expect(response.body).to eq user_errors.to_json }
    end

    context 'when sent user attributes are valid' do
      before { allow(UserCreator).to receive(:new).and_return creator }

      before { expect(creator).to receive(:on).twice.and_call_original }

      before { broadcast_succeeded creator, user }

      before { post :create, params: { user: user_attrs }, format: :json }

      it('returns status 201') { expect(response).to have_http_status 201 }

      it('returns created user') { expect(response.body).to eq user.to_json }
    end
  end

  describe 'PATCH #update' do
    context 'when not authenticated' do
      before { patch :update, params: { id: user.id, user: user_attrs }, format: :json }

      it('returns status 401') { expect(response).to have_http_status 401 }
    end

    context 'with authentication' do
      let(:updator) { UserUpdator.new user, user_attrs }

      before { sign_in user }

      context 'when user not authorized' do
        before { allow(subject).to receive(:resource).and_return user }

        before { expect(subject).to receive(:authorize).and_raise Pundit::NotAuthorizedError }

        before { patch :update, params: { id: user.id }, format: :json }

        it('returns status 403') { expect(response).to have_http_status 403 }
      end

      context 'with authorization' do
        before { allow(subject).to receive(:authorize).and_return true }

        context 'when request do not have requied keys' do
          before { allow(subject).to receive(:resource).and_return user }

          before { patch :update, params: { id: user.id }, format: :json }

          it('returns status 400') { expect(response).to have_http_status 400 }
        end

        context 'when requested user not found' do
          before { expect(subject).to receive(:resource).and_raise ActiveRecord::RecordNotFound }

          before { patch :update, params: { id: user.id, user: user_attrs }, format: :json }

          it('returns status 404') { expect(response).to have_http_status 404 }
        end

        context 'when sent user attributes are not valid' do
          before { allow(subject).to receive(:resource).and_return user }

          before { allow(ResourceUpdator).to receive(:new).and_return updator }

          before { expect(updator).to receive(:on).twice.and_call_original }

          before { broadcast_failed updator, user_errors }

          before { patch :update, params: { id: user.id, user: user_attrs }, format: :json }

          it('returns status 422') { expect(response).to have_http_status 422 }

          it('returns updated user') { expect(response.body).to eq user_errors.to_json }
        end

        context 'when sent user attributes are valid' do
          before { allow(subject).to receive(:resource).and_return user }

          before { allow(ResourceUpdator).to receive(:new).and_return updator }

          before { expect(updator).to receive(:on).twice.and_call_original }

          before { broadcast_succeeded updator, user }

          before { patch :update, params: { id: user.id, user: user_attrs }, format: :json }

          it('returns status 200') { expect(response).to have_http_status 200 }

          it('returns updated user') { expect(response.body).to eq user.to_json }
        end
      end
    end
  end

  describe 'GET #confirm' do
    let(:token) { JWTWorker.encode(user_id: user.id) }

    context 'when passed invalid token' do
      before { get :confirm, params: { token: 'invalid_token' }, format: :json }

      it('returns status 401') { expect(response).to have_http_status 401 }

      it('returns header "WWW-Authenticate"') do
        expect(response.header['WWW-Authenticate']).to eq 'Token realm="Application"'
      end
    end

    context 'with authentication' do
      before { allow(User).to receive(:find).and_return user }

      before { expect(subject).to receive(:authenticate_to_confirm) }

      context 'when user is not authorized' do
        before { allow(subject).to receive(:authorize).and_raise Pundit::NotAuthorizedError }

        before { get :confirm, params: { token: token }, format: :json }

        it('returns status 403') { expect(response).to have_http_status 403 }
      end

      context 'when user authorized' do
        let(:result_json) { { message: 'user confirmed' }.to_json }

        before { allow(subject).to receive(:current_user).and_return user }

        before { allow(subject).to receive(:authorize).and_return true }

        before { expect(user).to receive(:confirmed!) }

        before { get :confirm, params: { token: token }, format: :json }

        it('returns status 200') { expect(response).to have_http_status 200 }

        it "returns message 'user confirmed'" do
          expect(response.body).to eq result_json
        end
      end
    end
  end

  describe '#resource' do
    before { get :show, params: { id: 5 }, format: :json }

    before { allow(User).to receive(:find).with('5').and_return user }

    it('returns user') { expect(subject.send :resource).to eq user }
  end
end
