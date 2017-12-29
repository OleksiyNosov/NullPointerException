module Dispatchable
  def broadcast_succeeded worker, resource
    expect(worker).to receive(:call) { worker.send :broadcast, :succeeded, resource }
  end

  def broadcast_failed worker, errors
    expect(worker).to receive(:call) { worker.send :broadcast, :failed, errors }
  end
end
