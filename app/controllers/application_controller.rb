class ApplicationController < ActionController::Base
  helper_method :user_signed_in?, :current_user_name

  def user_signed_in?
    session[:token].present? && authenticate_token.present?
  end

  def current_user_name
    session[:user_name]
  end

  def authenticate_token
    token = session[:token]
    return nil unless token

    begin
      response = RestClient.post("#{ENV['AUTH_SERVICE_URL']}/api/v1/validate_token", {}.to_json, {
        Authorization: "Bearer #{token}",
        content_type: :json,
        accept: :json
      })      
      json_response = JSON.parse(response.body)
      session[:user_name] = json_response["user_name"]
      return json_response
    rescue RestClient::ExceptionWithResponse => e
      Rails.logger.error("Erro ao validar token: #{e.response}")
      reset_session
      nil
    end
  end

  def authenticate_user
    unless user_signed_in?
      flash[:alert] = "Você não tem permissão para realizar essa ação!"
      redirect_to root_path
    end
  end

end
