FactoryBot.define do
  factory :account do
    organization_id { SecureRandom.uuid }
  end
end
