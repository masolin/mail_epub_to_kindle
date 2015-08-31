class TaskMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.task_mailer.send_to_kindle.subject
  #
  def send_to_kindle(task)
    attachments[task.ebook_identifier] = File.read(task.ebook.current_path)
    mail to: task.email, subject: "From mail epub to kindle"
  end
end
