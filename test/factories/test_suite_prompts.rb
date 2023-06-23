FactoryBot.define do
  factory :test_suite_prompt do
    test_suite_id { SecureRandom.uuid }
    prompt_id { SecureRandom.uuid }
  end
end
