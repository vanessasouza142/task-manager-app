class ApplicationController < ActionController::Base
  helper_method :user_signed_in?, :current_user_name

  def user_signed_in?
    session[:token].present?
  end

  def current_user_name
    session[:user_name]
  end

  def authenticate_user
    unless user_signed_in?
      flash[:alert] = "Você não tem permissão para realizar essa ação!"
      redirect_to root_path
    end
  end

end
