require 'rails_helper'

RSpec.describe UserSerializer, type: :serializer do
  subject { UserSerializer.new create(:user) }

  let(:attributes) { subject.attributes.keys }

  it('have required keys in attributes') { expect(attributes).to eq %i[id email first_name last_name] }
end
