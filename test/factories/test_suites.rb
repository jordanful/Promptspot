FactoryBot.define do
  factory :test_runs do
    name { "Test Suite Example" }
    user_id
    account_id
    archived { false }
    mode { "completion" }
  end
end
