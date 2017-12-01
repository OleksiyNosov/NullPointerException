require 'rails_helper'

RSpec.describe UserSerializer do
  subject { UserSerializer.new create(:user) }

  let(:attributes) { subject.attributes.keys }

  it { expect(attributes).to eq %i[id email] }
end
