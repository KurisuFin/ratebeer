class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

	helper_method :current_user
	helper_method :current_user_admin?

	def current_user
#		session[:user_id] = nil
		return nil if session[:user_id].nil?
		User.find(session[:user_id])
	end

	def current_user_admin?
		user = current_user
		return nil if user.nil?
		current_user.admin
	end

	def ensure_that_logged_in
		redirect_to login_path, notice:'You should be logged in' if current_user.nil?
	end

	def ensure_that_admin
		raise ActionController::RoutingError.new('Forbidden') if current_user_admin?
	end
end
