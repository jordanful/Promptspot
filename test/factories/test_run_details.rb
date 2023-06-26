FactoryBot.define do
  factory :test_run_detail do
    test_run_id
    prompt_id
    input_id
    model_id
    prompt_version_id
    output { "This is some sample output" }
    status { "complete" }
  end
end
