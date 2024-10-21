class ScrapingJob < ApplicationJob
  queue_as :default

  def perform(task, action_done_by_user)
    Rails.logger.info "Iniciando o job para a tarefa #{task.id} em #{Time.current}"
    ScrapingService.send_scraping_request(task, action_done_by_user)
    Rails.logger.info "Job para a tarefa #{task.id} concluído em #{Time.current}"
  end
end
