require 'rails_helper'

RSpec.describe Api::AnswersController, type: :controller do
  it { is_expected.to be_an ApplicationController }

  it { is_expected.to be_kind_of Authenticatable }

  it { is_expected.to be_kind_of Exceptionable }

  let(:user) { instance_double User }

  let(:attributes) { answer.attributes }

  let(:invalid_attributes) { attributes.merge('body' => '') }

  let(:errors) { { 'body' => ["can't be blank"] }.to_json }

  let(:answer) { create(:answer) }

  let(:answer_values) { answer.slice(:id, :question_id) }

  describe 'GET #index' do
    describe 'answers exist' do
      before { create(:answer) }

      let!(:question) { create(:question) }

      let(:collection) { create_list(:answer, 2, question: question) }

      let!(:collection_values) { collection.map { |e| e.slice(:id, :question_id) } }

      before { get :index, params: { question_id: question.id }, format: :json }

      it('returns status 200') { expect(response).to have_http_status 200 }

      it 'returns answers' do
        expect(response_collection_values :id, :question_id).to have_same_elements collection_values
      end
    end
  end

  context 'with authentication' do
    before { sign_in user }

    describe 'POST #create' do
      context 'answer valid' do
        let(:answer_values) { answer.slice(:question_id, :body) }

        before { post :create, params: { answer: attributes }, format: :json }

        it('returns status 201') { expect(response).to have_http_status 201 }

        it('returns created answer') { expect(response_values :question_id, :body).to eq answer_values }
      end

      context 'bad request parametres' do
        before { post :create, params: { invalid_key: attributes }, format: :json }

        it('returns status 400') { expect(response).to have_http_status 400 }
      end

      context 'answer not valid' do
        before { post :create, params: { answer: invalid_attributes }, format: :json }

        it('returns status 422') { expect(response).to have_http_status 422 }

        it('returns errors') { expect(response.body).to eq errors }
      end
    end

    describe 'PATCH #update' do
      context 'answer updated' do
        before { patch :update, params: { id: answer.id, answer: attributes }, format: :json }

        it('returns status 200') { expect(response).to have_http_status 200 }

        it('returns updated answer') { expect(response_values :id, :question_id).to eq answer_values }
      end

      context 'bad request parametres' do
        before { post :update, params: { id: answer.id, invalid_key: attributes }, format: :json }

        it('returns status 400') { expect(response).to have_http_status 400 }
      end

      context 'answer is not exist' do
        before { expect(Answer).to receive(:find).and_raise ActiveRecord::RecordNotFound }

        before { post :update, params: { id: -1, invalid_key: attributes }, format: :json }

        it('returns status 404') { expect(response).to have_http_status 404 }
      end

      context 'answer not valid' do
        before { patch :update, params: { id: answer.id, answer: invalid_attributes }, format: :json }

        it('returns status 422') { expect(response).to have_http_status 422 }

        it('returns errors') { expect(response.body).to eq errors }
      end
    end

    describe 'DELETE #destroy' do
      context 'answer destroyed' do
        before { delete :destroy, params: { id: answer.id }, format: :json }

        it('returns status 204') { expect(response).to have_http_status 204 }
      end

      context 'answer not found' do
        before { expect(Answer).to receive(:find).and_raise ActiveRecord::RecordNotFound }

        before { delete :destroy, params: { id: -1 }, format: :json }

        it('returns status 404') { expect(response).to have_http_status 404 }
      end
    end
  end
end
