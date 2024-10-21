class ScrapingService

  def self.send_scraping_request(task, action_done_by_user)
    begin
      response = RestClient.post("#{ENV['WEB_SCRAPING_SERVICE_URL']}/api/v1/scraping",
        { task_id: task.id, task_url: task.url, action_done_by_user: action_done_by_user}.to_json,
        { content_type: :json, accept: :json }
      )
      message = JSON.parse(response.body)['message']
      Rails.logger.info("Resposta do microserviço de scraping: #{message}")
    rescue RestClient::ExceptionWithResponse => e
      Rails.logger.error("Erro ao enviar requisição de scraping: #{e.response}")
    end
  end
  
end