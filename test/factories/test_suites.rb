FactoryBot.define do
  factory :test_suite do
    name { "Test Suite Example" }
    user_id { SecureRandom.uuid }
    account_id { SecureRandom.uuid }
    archived { false }
    mode { "completion" }
  end
end
