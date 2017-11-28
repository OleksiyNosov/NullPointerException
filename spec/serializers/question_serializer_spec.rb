require 'rails_helper'

RSpec.describe QuestionSerializer do
  subject { QuestionSerializer.new create(:question) }

  let(:attributes) { subject.attributes.keys }

  it { expect(attributes).to eq %i[id title body tags] }
end
