class RoomsController < ApplicationController
  before_action :set_room, only: %w[show add_patients]

  def show
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

  def add_patients
    @patients_not_in_room = Patient.where(room_id: nil)
  end

  private

  def room_params
    params.require(:room).permit(:capacity)
  end

  def set_room
    @room = Room.includes(:patients).find(params[:id])
  end
end
