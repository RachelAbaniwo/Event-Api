module Api::V1
  class SessionsController < ApplicationController
    before_action :set_event, only: [:index]
    before_action :set_session, only: [:subscribe]
    before_action :set_admin, only: [:create]
    
    # GET /events/:event_id/sessions
    def index
      @sessions = @event.sessions.all
      render json: @sessions, status: 200
    end

    # POST /events/:event_id/sessions
    def create
      @session = Session.new(session_params)

      if @session.save
        render json: @session, status: :created
      else
        render json: @session.errors, status: :unprocessable_entity
      end

    end

    # POST /sessions/:id/subscribe
    def subscribe
      rsvp = @session.rsvp
      if params[:user_name] && params[:user_email]
        if @session.max_rsvp && rsvp < @session.max_rsvp
          params[:rsvp] = rsvp + 1
          if @session.update(rsvp: params[:rsvp])
            render json: @session
          else
            render json: @session.errors, status: :unprocessable_entity
          end
          @user = User.new(user_params)

          if @user.save
            return render json: @user, status: :created
          end
        else
          return render json: { message: "maximum number of subscriptions reached" }, status: :unprocessable_entity
        end

      else
        return render json: { message: "Provide your name and email address" }, status: :unprocessable_entity
      end
    end

    


    private
      # Use callbacks to share common setup or constraints between actions.

      def set_session
        return render json: { message: "ID is not a number"}, status: 422 unless Number.is_integer?(params[:id])
        begin
          @session = Session.find(params[:id])
        rescue ActiveRecord::RecordNotFound
          render json: { message: "Session with this ID not found"}, status: 404
        rescue
          render json: { error: "System Error" }, status: 500
        end
        
      end
    
      def set_event
        return render json: { message: "ID is not a number"}, status: 422 unless Number.is_integer?(params[:event_id])
        begin
          @event = Event.find(params[:event_id])
        rescue ActiveRecord::RecordNotFound
          render json: { message: "Event with this ID not found"}, status: 404
        rescue
          render json: { error: "System Error" }, status: 500
        end
      end
    
      def set_admin
        header = get_header()
        @admin = authorize_request(header)
      end

      def user_params
        params[:session_id] = params[:id]
        params[:name] = params[:user_name]
        params[:email] = params[:email]
        params.permit(:name, :email, :session_id)
      end

      # Only allow a trusted parameter "white list" through.
      def session_params
        params.permit(:session, :name, :event_id, :max_rsvp)
      end

  end
end
