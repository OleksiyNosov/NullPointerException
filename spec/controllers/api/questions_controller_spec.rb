require 'rails_helper'

RSpec.describe Api::QuestionsController, type: :controller do
  it { is_expected.to be_an ApplicationController }

  let(:attributes) { attributes_for(:question) }

  let(:serialized_attributes) { attributes.stringify_keys }

  let(:question) { instance_double(Question, id: 2, as_json: attributes, **attributes) }

  let(:resource_class) { Question }

  describe 'GET #show' do
    context 'question exist' do
      before { expect(subject).to receive(:resource).and_return question }

      before { get :show, params: { id: question.id }, format: :json }

      it('returns status 200') { expect(response).to have_http_status 200 }

      it('returns question') { expect(response_body).to eq serialized_attributes }
    end

    context 'question is not exist' do
      before { expect(subject).to receive(:resource).and_raise ActiveRecord::RecordNotFound }

      before { get :show, params: { id: question.id }, format: :json }

      it('returns status 404') { expect(response).to have_http_status 404 }
    end
  end

  describe 'POST #create' do
    before { expect(subject).to receive(:resource_class).and_return resource_class }

    before { expect(resource_class).to receive(:new).with(permit! attributes).and_return question }

    before { expect(question).to receive(:save) }

    context 'question was created' do
      before { expect(question).to receive(:valid?).and_return true }

      before { post :create, params: { question: attributes }, format: :json }

      it('returns status 201') { expect(response).to have_http_status 201 }

      it('returns question') { expect(response_body).to eq serialized_attributes }
    end

    context 'question was not created' do
      before { expect(question).to receive(:valid?).and_return false }

      before { expect(question).to receive(:errors).and_return :errors }

      before { post :create, params: { question: attributes }, format: :json }

      it('returns status 422') { expect(response).to have_http_status 422 }

      it('returns errors') { expect(response_body).to eq 'errors' }
    end
  end

  describe 'PATCH #update' do
    let(:params) { { id: question.id, question: attributes } }

    before { expect(subject).to receive(:resource).and_return question }

    before { expect(question).to receive(:update).with(permit! attributes).and_return question }

    context 'question was updated' do
      before { expect(question).to receive(:valid?).and_return true }

      before { patch :update, params: params, format: :json }

      it('returns status 200') { expect(response).to have_http_status 200 }

      it('returns updated question') { expect(response_body).to eq serialized_attributes }
    end

    context 'question was not updated' do
      before { expect(question).to receive(:valid?).and_return false }

      before { expect(question).to receive(:errors).and_return :errors }

      before { patch :update, params: params, format: :json }

      it('returns status 422') { expect(response).to have_http_status 422 }

      it('returns errors') { expect(response_body).to eq 'errors' }
    end
  end

  describe 'DELETE #destroy' do
    before { expect(subject).to receive(:resource).and_return question }

    before { expect(question).to receive(:destroy) }

    context 'question destroyed' do
      before { expect(question).to receive(:valid?).and_return true }

      before { delete :destroy, params: { id: question.id }, format: :json }

      it('returns status 204') { expect(response).to have_http_status 204 }
    end

    context 'question do not destroyed' do
      before { expect(question).to receive(:valid?).and_return false }

      before { expect(question).to receive(:errors).and_return :errors }

      before { delete :destroy, params: { id: question.id }, format: :json }

      it('returns status 422') { expect(response).to have_http_status 422 }

      it('returns errors') { expect(response_body).to eq 'errors' }
    end
  end
end
