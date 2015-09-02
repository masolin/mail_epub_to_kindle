class TasksController < ApplicationController
  def index
    @task = Task.new
  end

  def show
    @task = Task.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render json: { status: @task.status.to_s } }
    end
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      ConvertToMobiJob.perform_later(@task)
      @task.converting!
      redirect_to @task
    else
      flash.now[:toastr] = @task.errors.full_messages
      render :index
    end
  end

  private

  def task_params
    params.require(:task).permit(:email, :ebook)
  end
end
