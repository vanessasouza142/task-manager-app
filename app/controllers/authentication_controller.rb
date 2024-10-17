class AuthenticationController < ApplicationController
  
  def new    
  end

  def create
    begin
      response = RestClient.post("#{ENV['AUTH_SERVICE_URL']}/api/v1/register", user_params.to_json, { content_type: :json, accept: :json })
      response_body = JSON.parse(response.body)
      session[:token] = response_body['token']
      session[:user_name] = response_body['user']['name']
      flash[:notice] = "Boas-vindas! Seu registro foi realizado com sucesso!"
      redirect_to tasks_path
    rescue RestClient::ExceptionWithResponse => e
      error_response = JSON.parse(e.response.body)
      flash.now[:alert] = "Erro ao registrar: #{error_response['errors'].join(', ')}"
      render :new
    end
  end

  private

  def user_params
    params.permit(:name, :email, :password)
  end

end