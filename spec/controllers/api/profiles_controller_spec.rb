require 'rails_helper'

RSpec.describe Api::ProfilesController, type: :controller do
  it { is_expected.to be_an ApplicationController }

  let(:attributes) { attributes_for(:user) }

  let(:serialized_attributes) { attributes.stringify_keys }

  let(:resource) { instance_double User, id: 5, as_json: attributes, **attributes }

  let(:resource_class) { User }

  describe 'GET #show' do
    before { sign_in }

    before { expect(subject).to receive(:current_user).and_return resource }

    before { get :show, format: :json }

    it('returns status 200') { expect(response).to have_http_status 200 }

    it('returns user profile') { expect(response_body).to eq serialized_attributes }
  end

  describe 'POST #create' do
    before { expect(subject).to receive(:resource_class).and_return resource_class }

    before { expect(resource_class).to receive(:new).with(permit! attributes).and_return resource }

    before { expect(resource).to receive(:save) }

    context 'new user was created' do
      before do
        #
        # => resource.errors.empty?
        #
        expect(resource).to receive(:errors) do
          double.tap { |errors| expect(errors).to receive(:empty?).and_return true }
        end
      end

      before { allow(resource).to receive(:valid?).and_return true }

      before { post :create, params: { user: attributes }, format: :json }

      it('returns status 201') { expect(response).to have_http_status 201 }

      it('returns user profile') { expect(response_body).to eq serialized_attributes }
    end

    context 'new user was not created' do
      before do
        #
        # => resource.errors.empty?
        #
        expect(resource).to receive(:errors) do
          double.tap { |errors| expect(errors).to receive(:empty?).and_return false }
        end
      end

      before { allow(resource).to receive(:valid?).and_return false }

      before { expect(resource).to receive(:errors).and_return :errors }

      before { post :create, params: { user: attributes }, format: :json }

      it('returns status 422') { expect(response).to have_http_status 422 }

      it('returns errors') { expect(response_body).to eq 'errors' }
    end
  end

  describe 'PATCH #update' do
    before { sign_in }

    before { expect(subject).to receive(:resource).and_return resource }

    before { expect(resource).to receive(:update).with(permit! attributes) }

    before do
      #
      # => resource.sessions.destroy_all
      #
      expect(resource).to receive(:sessions) do
        double.tap { |sessions| expect(sessions).to receive(:destroy_all) }
      end
    end

    describe 'user profile was updated' do
      before do
        #
        # => resource.errors.empty?
        #
        expect(resource).to receive(:errors) do
          double.tap { |errors| expect(errors).to receive(:empty?).and_return true }
        end
      end

      before { allow(resource).to receive(:valid?).and_return true }

      before { patch :update, params: { user: attributes }, format: :json }

      it('returns status 200') { expect(response).to have_http_status 200 }

      it('returns updated profile') { expect(response_body).to eq serialized_attributes }
    end

    describe 'user profile was not updated' do
      before do
        #
        # => resource.errors.empty?
        #
        expect(resource).to receive(:errors) do
          double.tap { |errors| expect(errors).to receive(:empty?).and_return false }
        end
      end

      before { allow(resource).to receive(:valid?).and_return false }

      before { expect(resource).to receive(:errors).and_return :errors }

      before { patch :update, params: { user: attributes }, format: :json }

      it('returns status 422') { expect(response).to have_http_status 422 }

      it('returns errors') { expect(response_body).to eq 'errors' }
    end
  end

  describe '#resource_class' do
    its(:resource_class) { is_expected.to eq User }
  end

  describe '#resource' do
    before { allow(subject).to receive(:current_user).and_return resource }

    its(:resource) { is_expected.to eq resource }
  end
end
