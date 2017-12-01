require 'rails_helper'

RSpec.describe SessionSerializer do
  subject { SessionSerializer.new create(:session) }

  let(:attributes) { subject.attributes.keys }

  it { expect(attributes).to eq %i[id token] }
end
