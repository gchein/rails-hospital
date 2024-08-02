class PatientsController < ApplicationController
  before_action :set_patient, only: %w[show edit update]

  def index
    @patients = Patient.includes(:room).all
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
    @rooms = Room.all
  end

  def update
    room = Room.find(params[:patient][:room])

    new_params = patient_params.merge(room: room)

    if @patient.update(new_params)
      redirect_to patients_path
    else
      @errors = @patient.errors.full_messages.join("/")
      @rooms = Room.all
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def patient_params
    params.require(:patient).permit(:name, :age, :cpf, :gender, :room)
  end

  def set_patient
    @patient = Patient.includes(:room).find(params[:id])
  end
end
