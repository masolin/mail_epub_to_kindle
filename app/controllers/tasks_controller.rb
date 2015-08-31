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
      redirect_to @task
    else
      flash.now[:toastr] = "Upload fail!"
      render :index
    end
  end

  private

  def task_params
    params.require(:task).permit(:email)
  end
end
