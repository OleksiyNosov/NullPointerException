require 'rails_helper'

RSpec.describe Api::UsersController, type: :controller do
  it { is_expected.to be_an ApplicationController }

  it('authenticate and set user') { is_expected.to be_kind_of Authenticatable }

  it('handles exceptions') { is_expected.to be_kind_of ErrorHandable }

  let(:user) { instance_double User }

  let(:user_attrs) { attributes_for(:user) }

  let(:user_double) { instance_double(User, id: 5, as_json: user_attrs, **user_attrs) }

  let(:user_errors) { { 'email' => ["can't be blank"] } }

  describe 'GET #collection' do
    context 'when not authenticated' do
      before { get :index, format: :json }

      it('returns status 401') { expect(response).to have_http_status 401 }
    end

    context 'with authentication' do
      before { sign_in user }

      before { allow(subject).to receive(:collection).and_return [user_double] }

      before { get :index, format: :json }

      it('returns status 200') { expect(response).to have_http_status 200 }

      it('returns collection of users') { expect(response.body).to eq [user_double].to_json }
    end
  end

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
    context 'when request do not have requied keys' do
      before { post :create, params: { invalid_key: user_attrs }, format: :json }

      it('returns status 400') { expect(response).to have_http_status 400 }
    end

    context 'with dispather' do
      let(:creator) { ResourceCreator.new User, user_attrs }

      before { allow(ResourceCreator).to receive(:new).and_return creator }

      before { expect(creator).to receive(:on).twice.and_call_original }

      context 'when sent user attributes are valid' do
        before { allow(creator).to receive(:call) { creator.send :broadcast, :succeeded, user_double } }

        before { post :create, params: { user: user_attrs }, format: :json }

        it('returns status 201') { expect(response).to have_http_status 201 }

        it('returns created user') { expect(response.body).to eq user_double.to_json }
      end

      context 'when sent user attributes are not valid' do
        before { allow(creator).to receive(:call) { creator.send :broadcast, :failed, user_errors } }

        before { post :create, params: { user: user_attrs }, format: :json }

        it('returns status 422') { expect(response).to have_http_status 422 }

        it('returns errors') { expect(response.body).to eq user_errors.to_json }
      end
    end
  end

  describe 'PATCH #update' do
    context 'when not authenticated' do
      before { patch :update, params: { id: user_double.id, user: user_attrs }, format: :json }

      it('returns status 401') { expect(response).to have_http_status 401 }
    end

    context 'with authentication' do
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

      context 'with dispather' do
        let(:updator) { ResourceUpdator.new user_double, user_attrs }

        before { allow(subject).to receive(:resource).and_return user_double }

        before { allow(ResourceUpdator).to receive(:new).and_return updator }

        before { expect(updator).to receive(:on).twice.and_call_original }

        context 'when sent user attributes are valid' do
          before { expect(updator).to receive(:call) { updator.send :broadcast, :succeeded, user_double } }

          before { patch :update, params: { id: user_double.id, user: user_attrs }, format: :json }

          it('returns status 200') { expect(response).to have_http_status 200 }

          it('returns updated user') { expect(response.body).to eq user_double.to_json }
        end

        context 'when sent user attributes are not valid' do
          before { expect(updator).to receive(:call) { updator.send :broadcast, :failed, user_errors } }

          before { patch :update, params: { id: user_double.id, user: user_attrs }, format: :json }

          it('returns status 422') { expect(response).to have_http_status 422 }

          it('returns updated user') { expect(response.body).to eq user_errors.to_json }
        end
      end
    end
  end

  describe '#collection' do
    before { allow(User).to receive(:all).and_return [user_double] }

    it('returns collection of users') { expect(subject.send :collection).to eq [user_double] }
  end

  describe '#resource' do
    let(:id) { user_double.id }

    before do
      allow(subject).to receive(:params) do
        double.tap { |params| allow(params).to receive(:[]).with(:id).and_return id }
      end
    end

    before { allow(User).to receive(:find).with(id).and_return user_double }

    it('returns user') { expect(subject.send :resource).to eq user_double }
  end
end
