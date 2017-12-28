require 'rails_helper'

RSpec.describe Api::AnswersController, type: :controller do
  it { is_expected.to be_an ApplicationController }

  let(:user) { instance_double User }

  let(:question_double) { instance_double Question, id: 2 }

  let(:answer_attrs) { attributes_for(:answer) }

  let(:answer_double) { instance_double(Answer, id: 3, as_json: answer_attrs, **answer_attrs) }

  let(:answer_errors) { { 'body' => ["can't be blank"] } }

  describe 'GET #index' do
    context 'when question id not passed' do
      before { expect(subject).to receive(:collection).and_raise ActiveRecord::RecordNotFound }

      before { get :index, format: :json }

      it('returns status 404') { expect(response).to have_http_status 404 }
    end

    context 'when sent data is valid' do
      before { expect(subject).to receive(:collection).and_return [answer_double] }

      before { get :index, params: { question_id: question_double.id }, format: :json }

      it('returns status 200') { expect(response).to have_http_status 200 }

      it('returns collection of answers') { expect(response.body).to eq [answer_double].to_json }
    end
  end

  describe 'POST #create' do
    context 'when not authenticated' do
      before { post :create, params: { answer: answer_attrs }, format: :json }

      it('returns status 401') { expect(response).to have_http_status 401 }
    end

    context 'with authentication' do
      let(:creator) { AnswerCreator.new question_double, answer_attrs }

      before { sign_in user }

      before { allow(subject).to receive(:question).and_return question_double }

      context 'when request do not have requied keys' do
        before { post :create, params: { invalid_key: answer_attrs }, format: :json }

        it('returns status 400') { expect(response).to have_http_status 400 }
      end

      context 'when sent answer attributes are valid' do
        before { allow(AnswerCreator).to receive(:new).and_return(creator) }

        before { expect(creator).to receive(:on).twice.and_call_original }

        before { expect(creator).to receive(:call) { creator.send(:broadcast, :succeeded, answer_double) } }

        before { post :create, params: { answer: answer_attrs }, format: :json }

        it('returns status 201') { expect(response).to have_http_status 201 }

        it('returns created answer') { expect(response.body).to eq answer_double.to_json }
      end

      context 'when sent answer attributes are not valid' do
        before { allow(AnswerCreator).to receive(:new).and_return(creator) }

        before { expect(creator).to receive(:on).twice.and_call_original }

        before { expect(creator).to receive(:call) { creator.send(:broadcast, :failed, answer_errors) } }

        before { post :create, params: { answer: answer_attrs }, format: :json }

        it('returns status 422') { expect(response).to have_http_status 422 }

        it('returns created answer') { expect(response.body).to eq answer_errors.to_json }
      end
    end
  end

  describe 'PATCH #update' do
    context 'when not authenticated' do
      before { post :update, params: { id: answer_double.id, invalid_key: answer_attrs }, format: :json }

      it('returns status 401') { expect(response).to have_http_status 401 }
    end

    context 'with authentication' do
      let(:updator) { ResourceUpdator.new answer_double, answer_attrs }

      before { sign_in user }

      context 'when request do not have requied keys' do
        before { expect(subject).to receive(:resource) }

        before { post :update, params: { id: answer_double.id, invalid_key: answer_attrs }, format: :json }

        it('returns status 400') { expect(response).to have_http_status 400 }
      end

      context 'when requested answer did not found' do
        before { expect(subject).to receive(:resource).and_raise ActiveRecord::RecordNotFound }

        before { post :update, params: { id: answer_double.id, answer: answer_attrs }, format: :json }

        it('returns status 404') { expect(response).to have_http_status 404 }
      end

        context 'when sent answer attributes are valid' do
          before { allow(subject).to receive(:resource).and_return(answer_double) }

          before { allow(ResourceUpdator).to receive(:new).and_return(updator) }

          before { expect(updator).to receive(:on).twice.and_call_original }

          before { expect(updator).to receive(:call) { updator.send(:broadcast, :succeeded, answer_double) } }

          before { patch :update, params: { id: answer_double.id, answer: answer_attrs }, format: :json }

          it('returns status 200') { expect(response).to have_http_status 200 }

          it('returns updated answer') { expect(response.body).to eq answer_double.to_json }
        end

        context 'when sent answer attributes are not valid' do
          before { allow(subject).to receive(:resource).and_return(answer_double) }

          before { allow(ResourceUpdator).to receive(:new).and_return(updator) }

          before { expect(updator).to receive(:on).twice.and_call_original }

          before { expect(updator).to receive(:call) { updator.send(:broadcast, :failed, answer_errors) } }

          before { patch :update, params: { id: answer_double.id, answer: answer_attrs }, format: :json }

          it('returns status 422') { expect(response).to have_http_status 422 }

          it('returns errors') { expect(response.body).to eq answer_errors.to_json }
        end
    end
  end

  describe 'DELETE #destroy' do
    context 'when not authenticated' do
      before { delete :destroy, params: { id: answer_double.id }, format: :json }

      it('returns status 401') { expect(response).to have_http_status 401 }
    end

    context 'with authentication' do
      let(:destroyer) { ResourceDestroyer.new answer_double }

      before { sign_in user }

      context 'when requested answer did not found' do
        before { expect(subject).to receive(:resource).and_raise ActiveRecord::RecordNotFound }

        before { delete :destroy, params: { id: answer_double.id }, format: :json }

        it('returns status 404') { expect(response).to have_http_status 404 }
      end

      context 'when sent data is valid' do
        before { allow(subject).to receive(:resource).and_return answer_double }

        before { allow(ResourceDestroyer).to receive(:new).and_return(destroyer) }

        before { expect(destroyer).to receive(:on).twice.and_call_original }

        before { expect(destroyer).to receive(:call) { destroyer.send(:broadcast, :succeeded, answer_double) } }

        before { delete :destroy, params: { id: answer_double.id }, format: :json }

        it('returns status 204') { expect(response).to have_http_status 204 }
      end

      context 'when sent data is not valid' do
        before { allow(subject).to receive(:resource).and_return answer_double }

        before { allow(ResourceDestroyer).to receive(:new).and_return(destroyer) }

        before { expect(destroyer).to receive(:on).twice.and_call_original }

        before { expect(destroyer).to receive(:call) { destroyer.send(:broadcast, :failed, answer_errors) } }

        before { delete :destroy, params: { id: answer_double.id }, format: :json }

        it('returns status 422') { expect(response).to have_http_status 422 }
      end
    end
  end

  describe '#collection' do
    before do
      allow(subject).to receive(:question) do
        double.tap { |question| allow(question).to receive(:answers).and_return [answer_double] }
      end
    end

    it('returns collection of answers') { expect(subject.send :collection).to eq [answer_double] }
  end

  describe '#resource' do
    let(:id) { answer_double.id }

    before { delete :destroy, params: { id: 3 }, format: :json }

    before { allow(Answer).to receive(:find).with('3').and_return answer_double }

    it('returns answer') { expect(subject.send :resource).to eq answer_double }
  end

  describe '#question' do
    before { get :index, params: { question_id: 2 }, format: :json }

    before { allow(Question).to receive(:find).with('2').and_return question_double }

    it('returns question') { expect(subject.send :question).to eq question_double }
  end
end
