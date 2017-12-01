require 'rails_helper'

RSpec.describe Api::SessionsController, type: :controller do
  it { is_expected.to be_an ApplicationController }

  let(:password) { 'password' }

  let(:user) { FactoryGirl.create(:user, password: password) }

  let(:token) { SecureRandom.base64(64) }

  let(:attributes) { attributes_for(:session, user: user, token: token) }

  let(:serialized_attributes) { attributes.stringify_keys }

  let(:resource) { instance_double Session, id: 7, as_json: attributes, **attributes }

  let(:resource_create_attibutes) { { email: user.email, password: password } }

  describe 'GET #show' do
    before { sign_in }

    context 'session exist' do
      before { expect(subject).to receive(:resource).and_return resource }

      before { get :show, params: { id: resource.id }, format: :json }

      it('returns status 200') { expect(response).to have_http_status 200 }

      it('returns session') { expect(response_body).to eq serialized_attributes }
    end

    context 'session not exist' do
      before { expect(subject).to receive(:resource).and_raise ActiveRecord::RecordNotFound }

      before { get :show, params: { id: resource.id }, format: :json }

      it('returns status 404') { expect(response).to have_http_status 404 }
    end
  end

  describe 'POST #create' do
    before { allow(SecureRandom).to receive(:base64).with(64).and_return token }

    before { expect(Session).to receive(:new).with(user: user, token: token, password: password).and_return resource }

    before { expect(resource).to receive(:save) }

    context 'session was created' do
      before { expect(resource).to receive(:valid?).and_return true }

      before { post :create, params: { session: resource_create_attibutes }, format: :json }

      it('returns status 201') { expect(response).to have_http_status 201 }

      it('returns session') { expect(response_body).to eq serialized_attributes }
    end

    context 'session was not created' do
      before { expect(resource).to receive(:valid?).and_return false }

      before { expect(resource).to receive(:errors).and_return :errors }

      before { post :create, params: { session: resource_create_attibutes }, format: :json }

      it('returns status 422') { expect(response).to have_http_status 422 }

      it('returns errors') { expect(response_body).to eq 'errors' }
    end
  end

  describe 'DELETE #destroy' do
    before { sign_in user }

    before { expect(subject).to receive(:resource).and_return resource }

    before { expect(resource).to receive(:destroy) }

    context 'session was destroyed' do
      before { allow(resource).to receive(:valid?).and_return true }

      before { delete :destroy, params: { id: resource.id }, format: :json }

      it('returns status 204') { expect(response).to have_http_status 204 }
    end

    context 'session was not destroyed' do
      before { allow(resource).to receive(:valid?).and_return false }

      before { expect(resource).to receive(:errors) }

      before { delete :destroy, params: { id: resource.id }, format: :json }

      it('returns status 422') { expect(response).to have_http_status 422 }
    end
  end

  describe '#resource' do
    before do
      #
      # => params[:id]
      #
      expect(subject).to receive(:params) do
        double.tap { |params| expect(params).to receive(:[]).with(:id).and_return :session_id }
      end
    end

    before do
      #
      # => current_user.session.find_by
      #
      expect(subject).to receive(:current_user) do
        double.tap do |current_user|
          expect(current_user).to receive(:sessions) do
            double.tap { |sessions| expect(sessions).to receive(:find).with(:session_id).and_return resource }
          end
        end
      end
    end

    its(:resource) { is_expected.to eq resource }
  end
end
