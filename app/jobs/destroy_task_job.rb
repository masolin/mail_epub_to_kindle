class DestroyTaskJob < ActiveJob::Base
  queue_as :default

  def perform(task)
    task.destroy
  end
end
