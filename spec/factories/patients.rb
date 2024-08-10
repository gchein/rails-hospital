FactoryBot.define do
  sequence :patient_name do |n|
    "Patient #{n}"
  end

  factory :patient do
    name { generate(:patient_name) }
    age { 50 }
    gender { "Male" }
  end
end
