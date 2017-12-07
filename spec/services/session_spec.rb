require 'rails_helper'

RSpec.describe Session do
  let(:password) { SecureRandom.base64(32) }

  let(:user) { FactoryGirl.create :user, password: password }

  let(:email) { user.email }

  subject { Session.new email: email, password: password }

  let(:token) { subject.token }

  let(:exp) { 7.days.from_now.to_i }

  let(:headers) { { typ: 'JWT', alg: Session::ALGORITHM } }

  let(:payload) { { id: user.id, exp: exp } }

  describe '#token' do
    before do
      allow(JWT).to receive(:encode).with(payload, Session::SECRET_KEY, Session::ALGORITHM, headers).and_return token
    end

    its(:token) { is_expected.to eq token }
  end

  describe '#headers' do
    its(:headers) { is_expected.to eq headers }
  end

  describe '#payload' do
    its(:payload) { is_expected.to eq payload }
  end

  describe '#user' do
    before { allow(User).to receive(:find_by).with(email: user.email).and_return user }

    its(:user) { is_expected.to eq user }
  end
end
