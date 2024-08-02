class RoomsController < ApplicationController
  def show
    @room = Room.includes(:patients).find(params[:id])
    # Include current_occupancy as a scope?
  end

  def index
    @rooms = Room.includes(:patients).all
  end

  def new
    @room = Room.new
  end

  def create
    @room = Room.new(room_params)

    if @room.save
      redirect_to rooms_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def room_params
    params.require(:room).permit(:capacity)
  end
end
