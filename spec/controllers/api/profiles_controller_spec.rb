require 'rails_helper'

RSpec.describe Api::ProfilesController, type: :controller do
  it { is_expected.to be_an ApplicationController }

  let(:user_attrs) { attributes_for(:user) }

  let(:user) { instance_double(User, id: 5, as_json: user_attrs, **user_attrs) }

  let(:user_errors) { { attribute_name: %w[error1 error2] } }

  describe 'GET #show' do
    context 'when not authenticated' do
      before { get :show, format: :json }

      it('returns status 401') { expect(response).to have_http_status 401 }
    end

    context 'with authentication' do
      before { sign_in user }

      before { allow(subject).to receive(:resource).and_return user }

      context 'when not authorized' do
        before { expect(subject).to receive(:authorize).and_raise Pundit::NotAuthorizedError }

        before { get :show, format: :json }

        it('returns status 403') { expect(response).to have_http_status 403 }
      end

      context 'user is valid' do
        before { allow(subject).to receive(:authorize).and_return true }

        before { get :show, format: :json }

        it('returns status 200') { expect(response).to have_http_status 200 }

        it('returns user profile') { expect(response.body).to eq user.to_json }
      end
    end
  end

  describe '#resource' do
    before { allow(subject).to receive(:current_user).and_return user }

    it('returns user') { expect(subject.send :resource).to eq user }
  end
end
