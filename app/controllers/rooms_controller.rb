class RoomsController < ApplicationController
  before_action :set_room, only: %w[show update add_patients]

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
    respond_to do |format|
      format.html{
        @patients_without_room = Patient.where(room_id: nil).order(:name)
        @spots_in_room = @room.capacity - @room.current_occupancy
      }
      format.json{
        errors_arr = []

        error_hash = params.select { |key| key.match(/error_\d/) }
        error_hash.each_value do |error|
          errors_arr << error
        end

        @errors = errors_arr.join(" / ")
      }
    end
  end

  def update
    patient_ids = params[:room][:patient_ids].compact_blank

    @errors = []
    allocate_patients_to_rooms(patient_ids) unless patient_ids.empty?

    redirect_to @room if @errors.blank?
  end

  private

  def room_params
    params.require(:room).permit(:capacity)
  end

  def set_room
    @room = Room.includes(:patients).find(params[:id])
  end

  def allocate_patients_to_rooms(patient_ids)
    patient_ids.each do |patient_id|
      patient = Patient.find(patient_id)

      unless patient.allocate_to_room(@room)
        @errors = patient.errors.full_messages.join(" / ")

        add_patients
        render :add_patients, status: :unprocessable_entity
        break
      end
    end
  end
end
