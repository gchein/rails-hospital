require 'rails_helper'

RSpec.describe 'Patients Requests', type: :request do
  let(:patient) { create(:patient) }
  let(:valid_params) { attributes_for(:patient) }
  let(:invalid_params) { attributes_for(:patient, name: nil) }

  describe 'GET /patients -> #index' do
    it 'provides the expected response status and body' do
      n = (1..10).to_a.sample
      create_list(:patient, n)

      get patients_path
      expect(response).to have_http_status(200)
      expect(response.body.scan(/(Patient \d+)/).count).to eq(n)
    end
  end

  describe 'GET /patient -> #show' do
    context 'with an existing record' do
      it 'provides the expected response status and body' do
        patient_name = patient.name

        get patient_path(patient)
        expect(response).to have_http_status(200)
        expect(response.body).to include(patient_name)
      end
    end

    context 'with a non-existing record'  do
      it 'has an invalid response status' do
        patient.destroy

        get patient_path(patient)
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'GET /new_patient -> #new' do
    it 'provides the expected response status and body' do
      get new_patient_path
      expect(response).to have_http_status(200)
      expect(response.body).to match(%r{<(form)(.)*(action="/patients")(.)*(method="post")>})
    end
  end

  describe 'POST /patients -> #create' do
    context 'with valid parameters' do
      it "creates a new record" do
        expect {
          post patients_path, params: { patient: valid_params }
        }.to change(Patient, :count).by(1)
      end

      it "redirects correctly" do
        post patients_path, params: { patient: valid_params }
        expect(response).to redirect_to(patients_path)
      end
    end

    context 'with invalid parameters' do
      it "does not create a new record" do
        expect {
          post patients_path, params: { patient: invalid_params }
        }.not_to change(Patient, :count)
      end

      it "redirects correctly" do
        post patients_path, params: { patient: invalid_params }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to match(/class="invalid-feedback"/).or match(/id="error_messages"/)
      end
    end
  end

  describe 'GET /edit_patient -> #edit' do
    it 'has an valid response status and body' do
      get edit_patient_path(patient)
      expect(response).to have_http_status(200)
      expect(response.body).to match(%r{<(form)(.)*(action="/patients/\d+")(.)*(method="post")>})
    end
  end

  describe 'PATCH /patient -> #update' do
    let(:new_valid_params) { attributes_for(:patient, name: "Any String") }

    context 'with valid parameters' do
      it "updates the record and redirects correctly" do
        initial_patient_state = patient.attributes
        patch patient_path(patient), params: { patient: new_valid_params }
        patient.reload
        current_patient_state = patient.attributes

        expect(initial_patient_state).not_to eq(current_patient_state)
        expect(response).to redirect_to(patients_path)
      end
    end

    context 'with invalid parameters' do
      it "does not update the record and redirects correctly" do
        initial_patient_state = patient.attributes
        patch patient_path(patient), params: { patient: invalid_params }
        patient.reload
        current_patient_state = patient.attributes

        expect(initial_patient_state).to eq(current_patient_state)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to match(/class="invalid-feedback"/).or match(/id="error_messages"/)
      end
    end
  end

  describe 'POST  /discharge_patient -> #discharge_patient' do
    it 'should have a valid response and redirect' do
      post discharge_patient_path(patient)
      expect(response).to redirect_to(patient)
    end
  end
end
