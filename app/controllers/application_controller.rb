class ApplicationController < ActionController::API
  include Authorize
  include Number
  
  def get_header
    header = request.headers
  end

  def create_admin_credentials(admin)
    token = Authorize.create_token(admin.id)
      header = get_header()
      header["ADMIN-KEY"] = token[:token]
      admin_attributes = {
        accessToken: token[:token],
        expires_in: token[:exp]
      }
      render json: admin_attributes, status: :created
  end
end
