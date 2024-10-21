class Api::V1::TasksController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:update]

  def update
    task_id = params[:task_id]
    task_status = params[:task_status]
    result = params[:task_result]

    task = Task.find_by(id: task_id)
    if task.present?
      task.update(status: task_status, result: result)
      render json: { message: 'Tarefa atualizada com sucesso!' }, status: :ok
    else
      render json: { error: 'Tarefa não encontrada.' }, status: :not_found
    end
  end
end