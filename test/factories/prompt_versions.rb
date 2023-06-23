FactoryBot.define do
  factory :prompt_version do
    prompt_id { SecureRandom.uuid }
    user_id { SecureRandom.uuid }
    text { "This is an example prompt" }
    version_number { 1 }
  end
end
