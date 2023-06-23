FactoryBot.define do
  factory :prompt do
    status { "active" }
    account_id { SecureRandom.uuid }
  end
end
