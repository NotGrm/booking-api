#
class Api::BaseController < JSONAPI::ResourceController
  before_action :require_token

  private

  def require_token
    auth_token = Rails.configuration.authentication_token

    return if request.headers.include?('X_Auth_Token') && request.headers['X_Auth_Token'] == auth_token
    render json: { 'message': 'unauthenticated' }, status: 401
  end
end
