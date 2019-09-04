class ApplicationController < ActionController::API
 
  include Number
  
  def get_header
    header = request.headers
  end

  

  def create_token(admin_id)
    expiration_in_hours = 24
    time = expiration_in_hours.to_i
    begin
      token = JsonWebToken.encode(admin_id: admin_id)
      return {
        token: "Bearer " + "#{token}", 
        exp: "#{time}"+"h"
      }
    rescue 
      render json: { error: "System Error", location: "jwt" }, status: 500
    end
  end
  
  def authorize_request(header)
    header = header["ADMIN-KEY"]

    if header
      admin_header = header.split(' ').last
      
    else
      return render json: { error: "unauthorized" }, status: 401
    end
    begin
      @decoded = JsonWebToken.decode(admin_header)
      return Admin.find(@decoded[:admin_id].to_i)
    rescue ActiveRecord::RecordNotFound
      render json: { error: "unauthorized" }, status: 401
    rescue JWT::DecodeError
      render json: { error: "unauthorized" }, status: 401
    rescue
      render json: { error: "System Error" }, status: 500
    end
  end

  def create_admin_credentials(admin)
    token = create_token(admin.id)
      header = get_header()
      header["ADMIN-KEY"] = token[:token]
      admin_attributes = {
        accessToken: token[:token],
        expires_in: token[:exp]
      }
      render json: admin_attributes, status: :created
  end
end

