require 'rails_helper'

RSpec.describe Api::AnswersController, type: :controller do
  it { is_expected.to be_an ApplicationController }

  it('authenticate and set user') { is_expected.to be_kind_of Authenticatable }

  it('handles exceptions') { is_expected.to be_kind_of Exceptionable }

  let(:user) { instance_double User }

  let(:answer_attrs) { attributes_for(:answer) }

  let(:answer_double) { instance_double(Answer, id: 3, as_json: answer_attrs, **answer_attrs) }

  let(:answer_errors) { { 'body' => ["can't be blank"] } }

  describe 'GET #index' do
    before { expect(subject).to receive(:collection).and_return [answer_double] }

    before { get :index, format: :json }

    it('returns status 200') { expect(response).to have_http_status 200 }

    it('returns collection of answers') { expect(response.body).to eq [answer_double].to_json }
  end

  describe 'POST #create' do
    context 'when not authenticated' do
      before { post :create, params: { answer: answer_attrs }, format: :json }

      it('returns status 401') { expect(response).to have_http_status 401 }
    end

    context 'with authentication' do
      before { sign_in user }

      context 'when request have invalid structure' do
        before { post :create, params: { invalid_key: answer_attrs }, format: :json }

        it('returns status 400') { expect(response).to have_http_status 400 }
      end

      context 'with dispatcher' do
        let(:creator) { AnswerCreator.new answer_attrs }

        before { allow(AnswerCreator).to receive(:new).and_return(creator) }

        before { expect(creator).to receive(:on).twice.and_call_original }

        context 'when sent answer attributes are valid' do
          before { expect(creator).to receive(:call) { creator.send(:broadcast, :succeeded, answer_double) } }

          before { post :create, params: { answer: answer_attrs }, format: :json }

          it('returns status 201') { expect(response).to have_http_status 201 }

          it('returns created answer') { expect(response.body).to eq answer_double.to_json }
        end

        context 'when sent answer attributes are not valid' do
          before { expect(creator).to receive(:call) { creator.send(:broadcast, :failed, answer_errors) } }

          before { post :create, params: { answer: answer_attrs }, format: :json }

          it('returns status 422') { expect(response).to have_http_status 422 }

          it('returns created answer') { expect(response.body).to eq answer_errors.to_json }
        end
      end
    end
  end

  describe 'PATCH #update' do
    let(:params) { { id: answer_double.id, answer: answer_attrs } }

    context 'when not authenticated' do
      before { post :update, params: params, format: :json }

      it('returns status 401') { expect(response).to have_http_status 401 }
    end

    context 'with authentication' do
      before { sign_in user }

      context 'when request have invalid structure' do
        before { expect(subject).to receive(:resource) }

        before { post :update, params: { id: answer_double.id, invalid_key: answer_attrs }, format: :json }

        it('returns status 400') { expect(response).to have_http_status 400 }
      end

      context 'when requested answer did not found' do
        before { expect(subject).to receive(:resource).and_raise ActiveRecord::RecordNotFound }

        before { post :update, params: params, format: :json }

        it('returns status 404') { expect(response).to have_http_status 404 }
      end

      context 'with dispatcher' do
        let(:updator) { ResourceUpdator.new answer_double, answer_attrs }

        before { allow(subject).to receive(:resource).and_return(answer_double) }

        before { allow(ResourceUpdator).to receive(:new).and_return(updator) }

        before { expect(updator).to receive(:on).twice.and_call_original }

        context 'when sent answer attributes are valid' do
          before { expect(updator).to receive(:call) { updator.send(:broadcast, :succeeded, answer_double) } }

          before { patch :update, params: params, format: :json }

          it('returns status 200') { expect(response).to have_http_status 200 }

          it('returns updated answer') { expect(response.body).to eq answer_double.to_json }
        end

        context 'when sent answer attributes are not valid' do
          before { expect(updator).to receive(:call) { updator.send(:broadcast, :failed, answer_errors) } }

          before { patch :update, params: params, format: :json }

          it('returns status 422') { expect(response).to have_http_status 422 }

          it('returns errors') { expect(response.body).to eq answer_errors.to_json }
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when not authenticated' do
      before { delete :destroy, params: { id: answer_double.id }, format: :json }

      it('returns status 401') { expect(response).to have_http_status 401 }
    end

    context 'with authentication' do
      before { sign_in user }

      context 'when requested answer was destroyed' do
        let(:destroyer) { ResourceDestroyer.new answer_double }

        before { allow(subject).to receive(:resource).and_return answer_double }

        before { allow(ResourceDestroyer).to receive(:new).and_return(destroyer) }

        before { expect(destroyer).to receive(:on).twice.and_call_original }

        before { expect(destroyer).to receive(:call) { destroyer.send(:broadcast, :succeeded, answer_double) } }

        before { delete :destroy, params: { id: answer_double.id }, format: :json }

        it('returns status 204') { expect(response).to have_http_status 204 }
      end

      context 'when requested answer did not found' do
        before { expect(subject).to receive(:resource).and_raise ActiveRecord::RecordNotFound }

        before { delete :destroy, params: { id: answer_double.id }, format: :json }

        it('returns status 404') { expect(response).to have_http_status 404 }
      end
    end
  end

  describe '#collection' do
    let(:question) { create(:question) }

    let(:collection) { create_list(:answer, 2, question: question) }

    before { create(:answer) }

    before do
      allow(subject).to receive(:params) do
        double.tap { |params| allow(params).to receive(:[]).with(:question_id).and_return question.id }
      end
    end

    it('returns collection of answers') { expect(subject.send :collection).to have_same_elements collection }
  end

  describe '#resource' do
    let(:answer) { create(:answer) }

    before do
      allow(subject).to receive(:params) do
        double.tap { |params| allow(params).to receive(:[]).with(:id).and_return answer.id }
      end
    end

    it('returns answer') { expect(subject.send :resource).to eq answer }
  end
end
