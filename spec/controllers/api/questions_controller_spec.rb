require 'rails_helper'

RSpec.describe Api::QuestionsController, type: :controller do
  it { is_expected.to be_an ApplicationController }

  it('authenticate and set user') { is_expected.to be_kind_of Authenticatable }

  it('handles exceptions') { is_expected.to be_kind_of Exceptionable }

  let(:user) { instance_double User }

  let(:attributes) { question.attributes }

  let(:invalid_attributes) { attributes.merge('title' => '') }

  let(:errors) { { 'title' => ["can't be blank"] }.to_json }

  let(:question) { create(:question) }

  let(:question_values) { question.slice(:id, :title) }

  describe 'GET #index' do
    let!(:collection) { create_list(:question, 2) }

    let(:collection_values) { collection.map { |e| e.slice(:id, :title) } }

    before { get :index, format: :json }

    it('returns status 200') { expect(response).to have_http_status 200 }

    it 'returns collection of questions' do
      expect(response_collection_values :id, :title).to have_same_elements collection_values
    end
  end

  describe 'GET #show' do
    context 'when requested question was found' do
      before { get :show, params: { id: question.id }, format: :json }

      it('returns status 200') { expect(response).to have_http_status 200 }

      it('returns question') { expect(response_values :id, :title).to eq question_values }
    end

    context 'when requested question was not found' do
      before { expect(Question).to receive(:find).and_raise ActiveRecord::RecordNotFound }

      before { get :show, params: { id: -1 }, format: :json }

      it('returns status 404') { expect(response).to have_http_status 404 }
    end
  end

  context 'with authentication' do
    before { sign_in user }

    describe 'POST #create' do
      context 'when sent question attributes are valid' do
        before { post :create, params: { question: attributes }, format: :json }

        it('returns status 201') { expect(response).to have_http_status 201 }

        it('returns created question') { expect(response_values :title, :body).to eq question.slice(:title, :body) }
      end

      context 'when request have invalid structure' do
        before { post :create, params: { invalid_key: attributes }, format: :json }

        it('returns status 400') { expect(response).to have_http_status 400 }
      end

      context 'when sent question attributes are not valid' do
        before { post :create, params: { question: invalid_attributes }, format: :json }

        it('returns status 422') { expect(response).to have_http_status 422 }

        it('returns errors') { expect(response.body).to eq errors }
      end
    end

    describe 'PATCH #update' do
      let(:params) { { id: question.id, question: attributes } }

      context 'when sent question attributes are valid' do
        before { patch :update, params: params, format: :json }

        it('returns status 200') { expect(response).to have_http_status 200 }

        it('returns updated question') { expect(response_values :id, :title).to eq question_values }
      end

      context 'when request have invalid structure' do
        before { post :update, params: { id: question.id, invalid_key: attributes }, format: :json }

        it('returns status 400') { expect(response).to have_http_status 400 }
      end

      context 'when requested question did not found' do
        before { expect(Question).to receive(:find).and_raise ActiveRecord::RecordNotFound }

        before { post :update, params: { id: -1, invalid_key: attributes }, format: :json }

        it('returns status 404') { expect(response).to have_http_status 404 }
      end

      context 'when sent question attributes are not valid' do
        let(:params) { { id: question.id, question: invalid_attributes } }

        before { patch :update, params: params, format: :json }

        it('returns status 422') { expect(response).to have_http_status 422 }

        it('returns errors') { expect(response.body).to eq errors }
      end
    end

    describe 'DELETE #destroy' do
      context 'when requested question was destroyed' do
        before { delete :destroy, params: { id: question.id }, format: :json }

        it('returns status 204') { expect(response).to have_http_status 204 }
      end

      context 'when requested question did not found' do
        before { expect(Question).to receive(:find).and_raise ActiveRecord::RecordNotFound }

        before { delete :destroy, params: { id: -1 }, format: :json }

        it('returns status 404') { expect(response).to have_http_status 404 }
      end
    end
  end
end
