require 'rails_helper'

RSpec.describe QuestionSerializer, type: :serializer do
  let(:question) { build(:question, id: 2) }

  subject { described_class.new question }

  let(:result) do
    {
      id: question.id,
      title: question.title,
      body: question.body
    }
  end

  it("returns question's required keys and values") { expect(subject.attributes).to eq result }
end
