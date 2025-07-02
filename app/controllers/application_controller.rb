class ApplicationController < ActionController::API
	include CanCan::ControllerAdditions

	before_action :authorize_request
	attr_reader :current_user

	private

	def authorize_request
		header = request.headers['Authorization']
		header = header.split(' ').last if header
		
		decoded = JsonWebToken.decode(header)
		@current_user = User.find_by(id: decoded[:user_id]) if decoded
		
		rescue ActiveRecord::RecordNotFound
		render json: { error: 'Invalid token' }, status: :unauthorized
	end
end

