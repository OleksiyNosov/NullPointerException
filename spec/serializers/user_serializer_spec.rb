require 'rails_helper'

RSpec.describe UserSerializer, type: :serializer do
  let(:user) { build(:user, id: 5) }

  subject { described_class.new user }

  let(:result) do
    {
      id: user.id,
      email: user.email,
      first_name: user.first_name,
      last_name: user.last_name
    }
  end

  it("returns user's required keys and values") { expect(subject.attributes).to eq result }
end
