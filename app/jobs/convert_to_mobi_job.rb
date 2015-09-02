require 'os'

class ConvertToMobiJob < ActiveJob::Base
  queue_as :default

  def perform(task)
    ret = convert_to_mobi(task.ebook.current_path)
    if ret.nil?
      task.broken!
      DestroyTaskJob.set(wait: 1.minutes).perform_later(task)
    else
      task.update_attribute(:mobi_path, ret)
      TaskMailer.send_to_kindle(task).deliver_later
      task.mailing!
    end
  end

  private

  def convert_to_mobi(file_path)
    kindlegen_prefix_path = "#{Rails.root}/vendor/bin/"
    kindlegen_path = kindlegen_prefix_path + 'kindlegen_mac' if OS.mac?
    kindlegen_path = kindlegen_prefix_path + 'kindlegen_linux' if OS.linux?
    return nil unless system(kindlegen_path, file_path)
    file_path.sub(/.epub$/, '.mobi')
  end
end
