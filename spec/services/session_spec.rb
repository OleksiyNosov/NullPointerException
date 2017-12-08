require 'rails_helper'

RSpec.describe Session do
  let(:password) { SecureRandom.base64(32) }

  let(:user) { FactoryGirl.create :user, password: password }

  let(:email) { user&.email }

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
    before { allow(User).to receive(:find_by).with(email: email).and_return user }

    its(:user) { is_expected.to eq user }
  end

  describe '#valid?' do
    context 'all is good' do
      it('returns true') { expect(subject.valid?).to eq true }
    end

    context 'user is nil' do
      let(:user) { nil }

      it('returns false') { expect(subject.valid?).to eq false }
    end

    context 'password is wrong' do
      let(:user) { FactoryGirl.create :user, password: 'password' }

      let(:password) { 'wrong password' }

      it('returns false') { expect(subject.valid?).to eq false }
    end
  end

  describe '#errors' do
    context 'all is good' do
      let(:errors_hash) { {} }

      before { subject.valid? }

      it('returns emty hash') { expect(subject.errors.to_h).to eq errors_hash }
    end

    context 'user is nil' do
      let(:errors_hash) { { email: 'not found', password: 'is invalid' } }

      let(:user) { nil }

      before { subject.valid? }

      it('returns email and password error') { expect(subject.errors.to_h).to eq errors_hash }
    end

    context 'password is wrong' do
      let(:errors_hash) { { password: 'is invalid' } }

      let(:user) { FactoryGirl.create :user, password: 'password' }

      let(:password) { 'wrong password' }

      before { subject.valid? }

      it('returns password errors') { expect(subject.errors.to_h).to eq errors_hash }
    end
  end
end
