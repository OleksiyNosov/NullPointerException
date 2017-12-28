require 'rails_helper'

RSpec.describe Api::QuestionsController, type: :controller do
  it { is_expected.to be_an ApplicationController }

  let(:user) { instance_double User }

  let(:question_attrs) { attributes_for(:question) }

  let(:question_double) { instance_double(Question, id: 2, as_json: question_attrs, **question_attrs) }

  let(:question_errors) { { 'title' => ["can't be blank"] } }

  describe 'GET #index' do
    before { expect(subject).to receive(:collection).and_return [question_double] }

    before { get :index, format: :json }

    it('returns status 200') { expect(response).to have_http_status 200 }

    it('returns collection of questions') { expect(response.body).to eq [question_double].to_json }
  end

  describe 'GET #show' do
    context 'when requested question was found' do
      before { expect(subject).to receive(:resource).and_return question_double }

      before { get :show, params: { id: question_double.id }, format: :json }

      it('returns status 200') { expect(response).to have_http_status 200 }

      it('returns question') { expect(response.body).to eq question_double.to_json }
    end

    context 'when requested question was not found' do
      before { expect(Question).to receive(:find).and_raise ActiveRecord::RecordNotFound }

      before { get :show, params: { id: question_double.id }, format: :json }

      it('returns status 404') { expect(response).to have_http_status 404 }
    end
  end

  describe 'POST #create' do
    context 'when not authenticated' do
      before { post :create, params: { question: question_attrs }, format: :json }

      it('returns status 401') { expect(response).to have_http_status 401 }
    end

    context 'with authentication' do
      let(:creator) { ResourceCreator.new Question, question_attrs }

      before { sign_in user }

      context 'when request do not have requied keys' do
        before { post :create, params: { invalid_key: question_attrs }, format: :json }

        it('returns status 400') { expect(response).to have_http_status 400 }
      end

      context 'when sent question attributes are valid' do
        before { allow(ResourceCreator).to receive(:new).and_return(creator) }

        before { expect(creator).to receive(:on).twice.and_call_original }

        before { expect(creator).to receive(:call) { creator.send(:broadcast, :succeeded, question_double) } }

        before { post :create, params: { question: question_attrs }, format: :json }

        it('returns status 201') { expect(response).to have_http_status 201 }

        it('returns created question') { expect(response.body).to eq question_double.to_json }
      end

      context 'when sent question attributes are not valid' do
        before { allow(ResourceCreator).to receive(:new).and_return(creator) }

        before { expect(creator).to receive(:on).twice.and_call_original }

        before { expect(creator).to receive(:call) { creator.send(:broadcast, :failed, question_errors) } }

        before { post :create, params: { question: question_attrs }, format: :json }

        it('returns status 422') { expect(response).to have_http_status 422 }

        it('returns created question') { expect(response.body).to eq question_errors.to_json }
      end
    end
  end

  describe 'PATCH #update' do
    let(:params) { { id: question_double.id, question: question_attrs } }

    context 'when not authenticated' do
      before { post :update, params: params, format: :json }

      it('returns status 401') { expect(response).to have_http_status 401 }
    end

    context 'with authentication' do
      let(:updator) { ResourceUpdator.new question_double, question_attrs }

      before { sign_in user }

      context 'when request do not have requied keys' do
        before { expect(subject).to receive(:resource) }

        before { post :update, params: { id: question_double.id, invalid_key: question_attrs }, format: :json }

        it('returns status 400') { expect(response).to have_http_status 400 }
      end

      context 'when requested question did not found' do
        before { expect(subject).to receive(:resource).and_raise ActiveRecord::RecordNotFound }

        before { post :update, params: params, format: :json }

        it('returns status 404') { expect(response).to have_http_status 404 }
      end

      context 'when sent question attributes are valid' do
        before { allow(subject).to receive(:resource).and_return(question_double) }

        before { allow(ResourceUpdator).to receive(:new).and_return(updator) }

        before { expect(updator).to receive(:on).twice.and_call_original }

        before { expect(updator).to receive(:call) { updator.send(:broadcast, :succeeded, question_double) } }

        before { patch :update, params: params, format: :json }

        it('returns status 200') { expect(response).to have_http_status 200 }

        it('returns updated question') { expect(response.body).to eq question_double.to_json }
      end

      context 'when sent question attributes are not valid' do
        before { allow(subject).to receive(:resource).and_return(question_double) }

        before { allow(ResourceUpdator).to receive(:new).and_return(updator) }

        before { expect(updator).to receive(:on).twice.and_call_original }

        before { expect(updator).to receive(:call) { updator.send(:broadcast, :failed, question_errors) } }

        before { patch :update, params: params, format: :json }

        it('returns status 422') { expect(response).to have_http_status 422 }

        it('returns errors') { expect(response.body).to eq question_errors.to_json }
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when not authenticated' do
      before { delete :destroy, params: { id: question_double.id }, format: :json }

      it('returns status 401') { expect(response).to have_http_status 401 }
    end

    context 'with authentication' do
      let(:destroyer) { ResourceDestroyer.new question_double }

      before { sign_in user }

      context 'when requested question did not found' do
        before { expect(subject).to receive(:resource).and_raise ActiveRecord::RecordNotFound }

        before { delete :destroy, params: { id: question_double.id }, format: :json }

        it('returns status 404') { expect(response).to have_http_status 404 }
      end

      context 'when sent data is valid' do
        before { allow(subject).to receive(:resource).and_return question_double }

        before { allow(ResourceDestroyer).to receive(:new).and_return(destroyer) }

        before { expect(destroyer).to receive(:on).twice.and_call_original }

        before { expect(destroyer).to receive(:call) { destroyer.send(:broadcast, :succeeded, question_double) } }

        before { delete :destroy, params: { id: question_double.id }, format: :json }

        it('returns status 204') { expect(response).to have_http_status 204 }
      end

      context 'when sent data in not valid' do
        before { allow(subject).to receive(:resource).and_return question_double }

        before { allow(ResourceDestroyer).to receive(:new).and_return(destroyer) }

        before { expect(destroyer).to receive(:on).twice.and_call_original }

        before { expect(destroyer).to receive(:call) { destroyer.send(:broadcast, :failed, question_errors) } }

        before { delete :destroy, params: { id: question_double.id }, format: :json }

        it('returns status 422') { expect(response).to have_http_status 422 }
      end
    end
  end

  describe '#collection' do
    before { allow(Question).to receive(:all).and_return [question_double] }

    it('returns collection of questions') { expect(subject.send :collection).to eq [question_double] }
  end

  describe '#resource' do
    before { get :show, params: { id: 2 }, format: :json }

    before { allow(Question).to receive(:find).with('2').and_return question_double }

    it('returns question') { expect(subject.send :resource).to eq question_double }
  end
end
