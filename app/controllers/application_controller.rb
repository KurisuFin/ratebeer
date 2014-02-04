class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

	helper_method :current_user

	def current_user
		return nil if session[:user_id].nil?
		User.find(session[:user_id])
	end

	def ensure_that_logged_in
		redirect_to login_path, notice:'You should be logged in' if current_user.nil?
	end
end
