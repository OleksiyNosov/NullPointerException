require 'rails_helper'

RSpec.describe ResourceCrudWorker do
  describe '#initialize' do
    it('raise NotImplementedError') { expect { ResourceCrudWorker.new }.to raise_error NotImplementedError }
  end
end
