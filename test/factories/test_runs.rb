FactoryBot.define do
  factory :test_run do
    test_suite
    run_time { "2023-06-23 09:23:59" }
    status { "complete" }
    archived { false }
  end
end
