require 'rails_helper'

RSpec.describe Session do
  let(:user) { FactoryGirl.create :user }

  subject { Session.new user: user }

  let(:token) { subject.token }

  let(:exp) { 7.days.from_now.to_i }

  let(:headers) { { typ: 'JWT', alg: Session::ALGORITHM } }

  let(:payload) { { id: user.id, exp: exp } }

  describe '#token' do
    before {
      allow(JWT).to receive(:encode).with(payload, Session::SECRET_KEY, Session::ALGORITHM, headers).and_return token
    }

    its(:token) { is_expected.to eq token }
  end

  describe '#headers' do
    its(:headers) { is_expected.to eq headers }
  end

  describe '#payload' do
    its(:payload) { is_expected.to eq payload }
  end
end
