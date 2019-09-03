module Api::V1
  class UsersController < ApplicationController
    before_action :set_user, only: [:attend]
    before_action :set_admin, only: [:create]
    
    # POST user/:id/attend
    def attend
      if @user.update(attended: true)
        render json: { message: "success"}, status: 200
      else
        render json: @user.errors, status: :unprocessable_entity
      end

    end

    private
      def set_user
        return render json: { message: "ID is not a number"}, status: 422 unless Number.is_integer?(params[:id])
        begin
          @user = User.find(params[:id])
        rescue ActiveRecord::RecordNotFound
          render json: { message: "User with this ID not found"}, status: 404
        rescue
          render json: { error: "System Error" }, status: 500
        end
      end

      def set_admin
        header = get_header()
        @admin = Authorize.authorize_request(header)
      end
  end
end