class TasksController < ApplicationController
  def index
    @task = Task.new
  end

  def show
    @task = Task.find(params[:id])
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      TaskMailer.send_to_kindle(@task).deliver_now
      flash[:toastr] = 'Mail sent!'
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
end
