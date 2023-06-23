FactoryBot.define do
  factory :test_run_detail do
    test_run_id { SecureRandom.uuid }
    prompt_id { SecureRandom.uuid }
    input_id { SecureRandom.uuid }
    output { "This is some sample output" }
    status { "complete" }
    model_id { SecureRandom.uuid }
    prompt_version_id { SecureRandom.uuid }
  end
end
