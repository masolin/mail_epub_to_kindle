# Preview all emails at http://localhost:3000/rails/mailers/task_mailer
class TaskMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/task_mailer/send_to_kindle
  def send_to_kindle
    TaskMailer.send_to_kindle(Task.last)
  end

end
