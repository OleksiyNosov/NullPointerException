require 'rails_helper'

RSpec.describe SessionSerializer do
  subject { SessionSerializer.new Session.new user: create(:user) }

  let(:attributes) { subject.attributes.keys }

  it { expect(attributes).to eq %i[token] }
end
