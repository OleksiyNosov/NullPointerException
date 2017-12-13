require 'rails_helper'

RSpec.describe Api::AnswersController, type: :controller do
  it { is_expected.to be_an ApplicationController }

  it { is_expected.to be_kind_of Authenticatable }

  it { is_expected.to be_kind_of Resourceable }

  let(:user) { instance_double User }

  let(:attributes) { attributes_for(:answer) }

  let(:serialized_attributes) { attributes.stringify_keys }

  let(:answer) { instance_double Answer, id: 3, as_json: attributes, **attributes }

  let(:resource_class) { Answer }

  describe 'GET #index' do
    describe 'answers exist' do
      before { allow(Answer).to receive(:all).and_return [serialized_attributes] }

      before { get :index, format: :json }

      it('returns status 200') { expect(response).to have_http_status 200 }

      it('returns answers') { expect(response_body).to eq [serialized_attributes] }
    end

    describe 'answers dont exist' do
      before { expect(Answer).to receive(:all).and_raise ActiveRecord::RecordNotFound }

      before { get :index, format: :json }

      it('returns status 404') { expect(response).to have_http_status 404 }
    end
  end

  context 'with authentication' do
    before { sign_in user }

    describe 'POST #create' do
      let(:params) { { answer: attributes } }

      before { allow(subject).to receive(:resource_class).and_return resource_class }

      before { allow(resource_class).to receive(:new).with(permit! attributes).and_return answer }

      before { expect(answer).to receive(:save) }

      context 'answer valid' do
        before { expect(answer).to receive(:valid?).and_return true }

        before { post :create, params: params, format: :json }

        it('returns status 201') { expect(response).to have_http_status 201 }

        it('returns created answer') { expect(response_body).to eq serialized_attributes }
      end

      context 'answer not valid' do
        before { allow(answer).to receive(:valid?).and_return false }

        before { allow(answer).to receive(:errors).and_return :errors }

        before { post :create, params: params, format: :json }

        it('returns status 422') { expect(response).to have_http_status 422 }

        it('returns errors') { expect(response_body).to eq 'errors' }
      end
    end

    describe 'PATCH #update' do
      let(:params) { { id: answer.id, answer: attributes } }

      before { allow(subject).to receive(:resource).and_return answer }

      before { allow(answer).to receive(:update).with(permit! attributes).and_return answer }

      context 'answer updated' do
        before { allow(answer).to receive(:valid?).and_return true }

        before { patch :update, params: params, format: :json }

        it('returns status 200') { expect(response).to have_http_status 200 }

        it('returns updated answer') { expect(response_body).to eq serialized_attributes }
      end

      context 'answer not valid' do
        before { allow(answer).to receive(:valid?).and_return false }

        before { allow(answer).to receive(:errors).and_return :errors }

        before { patch :update, params: params, format: :json }

        it('returns status 422') { expect(response).to have_http_status 422 }

        it('returns errors') { expect(response_body).to eq 'errors' }
      end
    end

    describe 'DELETE #destroy' do
      let(:params) { { id: answer.id } }

      before { allow(subject).to receive(:resource).and_return answer }

      before { expect(answer).to receive(:destroy) }

      context 'answer destroyed' do
        before { allow(answer).to receive(:valid?).and_return true }

        before { delete :destroy, params: params, format: :json }

        it('returns status 204') { expect(response).to have_http_status 204 }
      end

      context 'answer not valid' do
        before { allow(answer).to receive(:valid?).and_return false }

        before { allow(answer).to receive(:errors).and_return :errors }

        before { delete :destroy, params: params, format: :json }

        it('returns status 422') { expect(response).to have_http_status 422 }

        it('returns errors') { expect(response_body).to eq 'errors' }
      end
    end
  end

  describe '#resource_class' do
    its(:resource_class) { is_expected.to eq Answer }
  end
end
