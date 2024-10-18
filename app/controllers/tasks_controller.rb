class TasksController < ApplicationController
  before_action :authenticate_user

  def index
    @tasks = Task.all    
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to @task, notice: 'Tarefa cadastrada com sucesso!'
    else
      flash.now[:alert] = "Tarefa não cadastrada: #{@task.errors.full_messages.join(', ')}"
      render 'new'
    end    
  end

  def show
    set_instance
  end

  private

  def task_params
    params.require(:task).permit(:url)
  end

  def set_instance
    @task = Task.find(params[:id])
  end

end