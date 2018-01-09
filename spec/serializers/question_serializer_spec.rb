require 'rails_helper'

RSpec.describe QuestionSerializer, type: :serializer do
  subject { QuestionSerializer.new create(:question) }

  let(:attributes) { subject.attributes.keys }

  it('have required keys in attributes') { expect(attributes).to eq %i[id title body] }
end
