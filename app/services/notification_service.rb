class NotificationService
  
  def self.send_notification(task, action, action_done_by_user)
    begin
      response = RestClient.post("#{ENV['NOTIFICATION_MICROSERVICE_URL']}/api/v1/notification",
        { task_id: task.id, task_url: task.url, task_status: task.status, action: action, action_done_by_user: action_done_by_user }.to_json,
        { content_type: :json, accept: :json }
      )
      message = JSON.parse(response.body)['message']
      Rails.logger.info("Resposta do microserviço de notificações: #{message}")
    rescue RestClient::ExceptionWithResponse => e
      Rails.logger.error("Erro ao enviar notificação: #{e.response}")
    end
  end

end