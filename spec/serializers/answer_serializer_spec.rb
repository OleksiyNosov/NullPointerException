require 'rails_helper'

RSpec.describe AnswerSerializer do
  subject { AnswerSerializer.new create(:answer) }

  let(:attributes) { subject.attributes.keys }

  it('have required keys in attributes') { expect(attributes).to eq %i[id question_id body] }
end
