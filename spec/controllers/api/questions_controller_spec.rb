require 'rails_helper'

RSpec.describe Api::QuestionsController, type: :controller do
  it { is_expected.to be_an ApplicationController }

  it { is_expected.to be_kind_of Authenticatable }

  let(:user) { instance_double User }

  let(:attributes) { question.attributes }

  let(:invalid_attributes) { attributes.merge('title' => '') }

  let(:errors) { { 'title' => ["can't be blank"] }.to_json }

  let(:question) { FactoryBot.create(:question) }

  let(:serialized_question) { QuestionSerializer.new(question) }

  let(:serialized_question_json) { serialized_question.to_json }

  describe 'GET #index' do
    describe 'questions exist' do
      before { expect(subject).to receive(:collection).and_return :collection }

      before { get :index, format: :json }

      it('returns status 200') { expect(response).to have_http_status 200 }

      it('returns questions') { expect(response.body).to eq :collection.to_json }
    end
  end

  describe 'GET #show' do
    context 'question exist' do
      before { get :show, params: { id: question.id }, format: :json }

      it('returns status 200') { expect(response).to have_http_status 200 }

      it('returns question') { expect(response.body).to eq serialized_question_json }
    end

    context 'question is not exist' do
      before { get :show, params: { id: -1 }, format: :json }

      it('returns status 404') { expect(response).to have_http_status 404 }
    end
  end

  context 'with authentication' do
    before { sign_in user }

    describe 'POST #create' do
      context 'question was created' do
        let(:serialized_attributes) { serialized_question.to_h.without(:id).stringify_keys }

        before { post :create, params: { question: attributes }, format: :json }

        it('returns status 201') { expect(response).to have_http_status 201 }

        it('returns question') { expect(JSON.parse response.body).to include serialized_attributes }
      end

      context 'question was not created' do
        before { post :create, params: { question: invalid_attributes }, format: :json }

        it('returns status 422') { expect(response).to have_http_status 422 }

        it('returns errors') { expect(response.body).to eq errors }
      end
    end

    describe 'PATCH #update' do
      let(:params) { { id: question.id, question: attributes } }

      context 'question was updated' do
        before { patch :update, params: params, format: :json }

        it('returns status 200') { expect(response).to have_http_status 200 }

        it('returns updated question') { expect(response.body).to eq serialized_question_json }
      end

      context 'question was not updated' do
        let(:params) { { id: question.id, question: invalid_attributes } }

        before { patch :update, params: params, format: :json }

        it('returns status 422') { expect(response).to have_http_status 422 }

        it('returns errors') { expect(response.body).to eq errors }
      end
    end

    describe 'DELETE #destroy' do
      context 'question destroyed' do
        before { delete :destroy, params: { id: question.id }, format: :json }

        it('returns status 204') { expect(response).to have_http_status 204 }
      end
    end
  end
end
