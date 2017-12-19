require 'rails_helper'

RSpec.describe Api::AnswersController, type: :controller do
  it { is_expected.to be_an ApplicationController }

  it { is_expected.to be_kind_of Authenticatable }

  let(:user) { instance_double User }

  let(:attributes) { answer.attributes }

  let(:invalid_attributes) { attributes.merge('body' => '') }

  let(:errors) { { 'body' => ["can't be blank"] }.to_json }

  let(:answer) { FactoryBot.create(:answer) }

  let(:serialized_answer) { AnswerSerializer.new(answer) }

  let(:serialized_answer_json) { serialized_answer.to_json }

  describe 'GET #index' do
    describe 'answers exist' do
      before { Answer.destroy_all }

      let(:collection) { FactoryBot.create_list(:answer, 2) }

      let!(:collection_json) { collection.map { |element| AnswerSerializer.new(element) }.to_json }

      before { get :index, format: :json }

      it('returns status 200') { expect(response).to have_http_status 200 }

      it('returns answers') { expect(response.body).to eq collection_json }
    end
  end

  context 'with authentication' do
    before { sign_in user }

    describe 'POST #create' do
      context 'answer valid' do
        let(:serialized_attributes) { serialized_answer.to_h.without(:id).stringify_keys }

        before { post :create, params: { answer: attributes }, format: :json }

        it('returns status 201') { expect(response).to have_http_status 201 }

        it('returns created answer') { expect(JSON.parse response.body).to include serialized_attributes }
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

        it('returns updated answer') { expect(response.body).to eq serialized_answer_json }
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
    end
  end
end
