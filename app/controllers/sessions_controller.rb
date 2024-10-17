class SessionsController < ApplicationController

  def new    
  end

  def create
    begin
      response = RestClient.post("#{ENV['AUTH_SERVICE_URL']}/api/v1/login", user_params.to_json, { content_type: :json, accept: :json })
      response_body = JSON.parse(response.body)
      session[:token] = response_body['token']
      session[:user_name] = response_body['user']['name']
      flash[:notice] = "Login realizado com sucesso!"
      redirect_to tasks_path
    rescue RestClient::ExceptionWithResponse => e
      error_response = JSON.parse(e.response.body)
      flash.now[:alert] = "Erro ao realizar login: #{error_response['error']}"
      render :new
    end    
  end

  def destroy
    reset_session
    redirect_to root_path, notice: "Logout realizado com sucesso!"
  end

  private

  def user_params
    params.permit(:email, :password)
  end

end