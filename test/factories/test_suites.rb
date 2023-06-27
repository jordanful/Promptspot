FactoryBot.define do
  factory :test_suite do
    user
    account
    name { "Test Suite Example" }
    mode { "completion" }
    archived { false }
  end
end
