module Api::V1
  class AdminsController < ApplicationController
  
    # POST /admins
    def create
      begin
        @admin = Admin.new(admin_params)
      rescue
        render json: { error: "System Error" }, status: 500
      end
  
      if @admin.save
        create_admin_credentials(@admin)
      else
        render json: @admin.errors, status: :unprocessable_entity
      end
      
    end

    # POST /admins/login
    def login
      if params[:email]
        @admin = Admin.find_by_email(params[:email])
        if @admin == nil
          return render json: { error: "email or password invalid" }, status: 401
        end
        if params[:password]
          admin_password = BCrypt::Password.new(@admin.password)
          if admin_password == params[:password]
            create_admin_credentials(@admin)
          else
            return render json: { error: "email or password invalid" }, status: 401
          end
        else
          return render json: { error: "password required" }, status: 422
        end

      else
        return render json: { error: "email required" }, status: 422
      end
    end
    
    private
      # Only allow a trusted parameter "white list" through.
      def admin_params
        params.permit(:admin, :name, :email, :password)
      end


  end
    
end