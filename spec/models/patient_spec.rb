require 'rails_helper'

RSpec.describe Patient, type: :model do
  context 'validations' do
    context 'default validations' do
      let(:patient) { build(:patient) }

      it 'is valid with all required fields' do
        expect(patient).to be_valid
      end

      it 'is invalid without a name' do
        patient.name = nil
        expect(patient).not_to be_valid
        expect(patient.errors[:name]).to include("can't be blank")
      end

      it 'is invalid without an age' do
        patient.age = nil
        expect(patient).not_to be_valid
        expect(patient.errors[:age]).to include("can't be blank")
      end

      it 'is invalid without a gender' do
        patient.gender = nil
        expect(patient).not_to be_valid
        expect(patient.errors[:gender]).to include("can't be blank")
      end

      it 'is invalid with an incorrect gender type' do
        patient.gender = 'Invalid Type'
        expect(patient).not_to be_valid
        expect(patient.errors[:gender]).to include("is not included in the list")
      end
    end

    context 'custom validations' do
      describe '#patient_able_to_enter_room?' do
        it 'should be able to enter a room with space left' do
          room     = create(:room)
          patient  = create(:patient, room:)

          expect(patient).to be_valid
        end

        it 'should not be able to enter a full room' do
          room = create(:room, capacity: 1)
          create(:patient, room:)
          patient = build(:patient, room:)

          expect(patient).not_to be_valid
          expect(patient.errors[:base]).to include("This room is full")
        end
      end

      describe '#changed_to_valid_room?' do
        let(:room) { create(:room) }

        it 'should be able to be transfered to a valid room, if under care' do
          patient = build(:patient, room:)

          expect(patient).to be_valid
        end

        it 'should not be assignable a null room, if under care' do
          patient = create(:patient, room:)

          patient.room = nil

          expect(patient).not_to be_valid
          expect(patient.errors[:base]).to include("Please select a valid room")
        end

        it 'should be assignable a null room, if not under care' do
          patient = build(:patient, room:)

          patient.under_care = false
          patient.room = nil

          expect(patient).to be_valid
        end
      end
    end
  end

  context 'associations' do
    describe 'rooms association' do
      let(:room_association) { Patient.reflect_on_association(:room) }

      it 'belongs to a room' do
        expect(room_association.macro).to eq(:belongs_to)
      end

      it 'can have no room' do
        optional_foreign_key = room_association.instance_values["options"][:optional]
        expect(optional_foreign_key).to be true
      end
    end
  end

  context 'custom methods' do
    describe '#allocate_to_room' do
      it 'should have changed to a new room' do
        rooms = create_list(:room, 2)
        patient = build(:patient, room: rooms.first)
        starting_room = patient.room

        patient.allocate_to_room(rooms.last)
        current_room = patient.room

        expect(current_room).to eq(rooms.last)
        expect(starting_room).not_to eq(current_room)
      end
    end

    describe '#discharge' do
      it 'should discharge the patient' do
        room = create(:room)
        patient = build(:patient, room:)

        expect(patient.under_care).to be false
        expect(patient.room).to be nil
      end
    end
  end
end
