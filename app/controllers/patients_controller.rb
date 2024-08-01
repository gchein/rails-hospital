class PatientsController < ApplicationController
  def index
    @patients = Patient.includes(:room).all
  end

  def show
    @patient = Patient.includes(:room).find(params[:id])
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

  private

  def patient_params
    params.require(:patient).permit(:name, :age, :cpf, :gender)
  end
end
