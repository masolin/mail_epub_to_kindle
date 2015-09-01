require 'os'

class TasksController < ApplicationController
  def index
    @task = Task.new
  end

  def show
    @task = Task.find(params[:id])
    case @task.status
    when 'initial'
      flash[:toastr] = 'File is uploading.'
    when 'converting'
      flash[:toastr] = 'File is converting.'
    when 'broken'
      flash[:toastr] = 'File is broken.'
    when 'mailing'
      flash[:toastr] = 'File is mailing.'
    when 'sent'
      flash[:toastr] = 'File is sent.'
    end
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      ConvertToMobiJob.perform_later(@task)
      @task.converting!
      redirect_to @task
    else
      flash.now[:toastr] = 'Upload fail!'
      render :index
    end
  end

  private

  def task_params
    params.require(:task).permit(:email, :ebook)
  end

  def convert_to_mobi(file_path)
    kindlegen_prefix_path = "#{Rails.root}/vendor/bin/"
    kindlegen_path = kindlegen_prefix_path + 'kindlegen_mac' if OS.mac?
    kindlegen_path = kindlegen_prefix_path + 'kindlegen_linux' if OS.linux?
    return nil unless system(kindlegen_path, file_path)
    file_path.sub(/.epub$/, '.mobi')
  end

  def convert_and_send_mail(task)
    ret = convert_to_mobi(task.ebook.current_path)
    if ret.nil?
      flash[:toastr] = 'The file is broken!'
      task.destroy
      redirect_to root_url
    else
      task.update_attribute(:mobi_path, ret)
      TaskMailer.send_to_kindle(task).deliver_now
      flash[:toastr] = 'Mail sent!'
      redirect_to task
      task.destroy
    end
  end
end
