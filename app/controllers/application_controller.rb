class ApplicationController < ActionController::Base
  # before_action :authenticate_request
  protect_from_forgery with: :null_session

  private

  def authenticate_user
    header = request.headers['Authorization']
    token = header.split(' ').last if header
    p token
    p 'token'
    begin
      @decoded = JsonWebToken.decode(token)
      p @decoded
      @current_user = User.find(@decoded[:user_id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { error: 'Invalid token' }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { error: 'Invalid token' }, status: :unauthorized
    end
  end
end
