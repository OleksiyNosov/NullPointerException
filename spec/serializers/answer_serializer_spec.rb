require 'rails_helper'

RSpec.describe AnswerSerializer, type: :serializer do
  let(:answer) { build(:answer, id: 3) }

  subject { described_class.new answer }

  let(:result) do
    {
      id: answer.id,
      question_id: answer.question_id,
      user_id: answer.user_id,
      body: answer.body
    }
  end

  it("returns answer's required keys and values") { expect(subject.attributes).to eq result }
end
