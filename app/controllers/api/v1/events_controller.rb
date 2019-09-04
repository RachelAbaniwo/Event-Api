module Api::V1
  class EventsController < ApplicationController
    before_action :set_admin, only: [:create, :attended]
    before_action :set_event, only: [:show, :attended]

    # GET /events
    def index
      @events = Event.all

      render json: @events
    end

    # GET /events/:id
    def show
      render json: @event
    end

    # POST /events
    def create
      params[:admin_id] = @admin.id
      @event = Event.new(event_params)

      if @event.save
        render json: @event, status: :created
      else
        render json: @event.errors, status: :unprocessable_entity
      end
    end

    # GET /events/:id/attendance
    def attended
      begin 
        @attended = User.where(event_id: params[:id], attended: true).count
      rescue
        raise render json: { error: "System Error" }, status: 500
      end

      render json: { attendees: @attended }, status: 200
    end

  
    

    private

      def set_admin
        header = get_header()
        @admin = authorize_request(header)
      end

      def set_event
        return render json: { message: "ID is not a number"}, status: 422 unless Number.is_integer?(params[:id])
        begin
          @event = Event.find(params[:id])
        rescue ActiveRecord::RecordNotFound
          render json: { message: "Event with this ID not found"}, status: 404
        rescue
          render json: { error: "System Error" }, status: 500
        end
      end

      # Only allow a trusted parameter "white list" through.
      def event_params
        params.permit(:event, :name, :admin_id)
      end

  end
end
