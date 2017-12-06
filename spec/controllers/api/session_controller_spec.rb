require 'rails_helper'

RSpec.describe Api::SessionsController, type: :controller do
  it { is_expected.to be_an ApplicationController }

  let(:password) { 'password' }

  let(:user) { FactoryGirl.create(:user, password: password) }

  let(:attributes) { { email: user.email, password: password } }

  let(:session) { Session.new user: user }

  let(:token) { session.token }

  let(:result) { { token: token }.stringify_keys }

  describe 'POST #create' do
    before { expect(Session).to receive(:new).with(user: user).and_return session }

    context 'session was created' do
      before do
        #
        # => session.errors.empty?
        #
        expect(session).to receive(:errors) do
          double.tap { |errors| expect(errors).to receive(:empty?).and_return true }
        end
      end

      before { expect(session).to receive(:valid?).and_return true }

      before { post :create, params: { session: attributes }, format: :json }

      it('returns status 201') { expect(response).to have_http_status 201 }

      it('returns session') { expect(response_body).to eq result }
    end

    context 'session was not created' do
      before do
        #
        # => session.errors.empty?
        #
        expect(session).to receive(:errors) do
          double.tap { |errors| expect(errors).to receive(:empty?).and_return true }
        end
      end

      before { expect(session).to receive(:valid?).and_return false }

      before { expect(session).to receive(:errors).and_return :errors }

      before { post :create, params: { session: attributes }, format: :json }

      it('returns status 422') { expect(response).to have_http_status 422 }

      it('returns errors') { expect(response_body).to eq 'errors' }
    end
  end

  describe '#resource_class' do
    its(:resource_class) { is_expected.to eq Session }
  end
end
