class TaskMailer < ApplicationMailer
  after_action :status_to_sent
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.task_mailer.send_to_kindle.subject
  #
  def send_to_kindle(task)
    @task = task
    mobi_name = @task.ebook_identifier.sub(/.epub$/, '.mobi')
    attachments[mobi_name] = File.read(@task.mobi_path)
    mail to: @task.email, subject: "Convert"
  end

  private

  def status_to_sent
    @task.sent!
    DestroyTaskJob.set(wait: 5.minutes).perform_later(@task)
  end
end
