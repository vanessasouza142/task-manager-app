class TasksController < ApplicationController
  before_action :authenticate_user

  def index
    @tasks = Task.all.order(id: :desc)
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      NotificationService.send_notification(@task, 'create', current_user_name)
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
      NotificationService.send_notification(@task, 'update', current_user_name)
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

  def run_scraping
    pending_tasks = Task.all.status_pending

    if pending_tasks.any?
      pending_tasks.each do |task|
        task.update(status: 'in_progress')
        ScrapingJob.perform_later(task, current_user_name)
      end
      redirect_to tasks_path, notice: 'Scraping iniciado para todas as tarefas pendentes.'
    else
      redirect_to tasks_path, alert: 'Não há tarefas pendentes no momento.'
    end
  end

  private

  def task_params
    params.require(:task).permit(:url, :result)
  end

  def set_instance
    @task = Task.find(params[:id])
  end

end