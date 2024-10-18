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

  def edit
    set_instance
  end

  def update
    set_instance
    if @task.update(task_params)
      redirect_to @task, notice: 'Tarefa atualizada com sucesso!'
    else
      flash.now[:alert] = "Tarefa não atualizada: #{@task.errors.full_messages.join(', ')}"
      render 'edit'
    end     
  end

  def destroy
    set_instance
    @task.destroy
    flash[:notice] = 'Tarefa excluída com sucesso!'
    redirect_to tasks_path
  end

  private

  def task_params
    params.require(:task).permit(:url)
  end

  def set_instance
    @task = Task.find(params[:id])
  end

end