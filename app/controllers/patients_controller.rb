class PatientsController < ApplicationController
  before_action :set_patient, only: %w[show edit update discharge_patient]

  def index
    @patients = Patient.includes(:room).all.order(:id)
  end

  def show
    @room = @patient.room
  end

  def new
    @patient = Patient.new
  end

  def create
    @patient = Patient.new(patient_params)

    if @patient.save
      redirect_to patients_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    find_room_ids
  end

  def update
    room_id = params[:patient][:room_id]
    room = Room.find(room_id) unless room_id.blank?

    new_params = patient_params.merge(room: room)

    if @patient.update(new_params)
      redirect_to patients_path
    else
      @errors = @patient.errors.full_messages.join(" / ")

      edit
      render :edit, status: :unprocessable_entity
    end
  end

  def discharge_patient
    if @patient.discharge
      redirect_to @patient
    else
      @errors = @patient.errors.full_messages.join(" / ")

      edit
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def patient_params
    params.require(:patient).permit(:name, :age, :cpf, :gender, :room_id, :under_care)
  end

  def set_patient
    @patient = Patient.includes(:room).find(params[:id])
  end

  def find_room_ids
    @room_ids = Room.pluck(:id)
  end
end
