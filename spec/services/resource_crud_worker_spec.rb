require 'rails_helper'

RSpec.describe ResourceCrudWorker do
  describe '#initialize' do
    it('verifies that ResourceCrudWorker is an abstract class') do
      expect { described_class.new }.to raise_error NotImplementedError
    end
  end
end
