module Authorize
  def self.create_token(admin_id)
    expiration_in_hours = 24
    time = expiration_in_hours.to_i
    begin
      token = JsonWebToken.encode(admin_id: admin_id)
      return {
        token: "Bearer " + "#{token}", 
        exp: "#{time}"+"h"
      }
    rescue 
      raise render json: { error: "System Error", location: "jwt" }, status: 500
    end
  end

  def self.authorize_request(header)
    header = header["ADMIN-KEY"]

    if header
      admin_header = header.split(' ').last
      
    else
      raise render json: { error: "unauthorized" }, status: 401
    end
    begin
      @decoded = JsonWebToken.decode(admin_header)
      return Admin.find(@decoded[:admin_id].to_i)
    rescue ActiveRecord::RecordNotFound
      raise render json: { error: "unauthorized" }, status: 401
    rescue JWT::DecodeError
      raise render json: { error: "unauthorized" }, status: 401
    rescue
      raise render json: { error: "System Error" }, status: 500
    end
  end
end