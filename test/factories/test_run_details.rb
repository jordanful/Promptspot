FactoryBot.define do
  factory :test_run_detail do
    test_run
    prompt
    input
    model
    prompt_version
    output { "This is some sample output" }
    status { "complete" }
  end
end
