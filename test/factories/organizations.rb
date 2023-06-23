FactoryBot.define do
  factory :organization do
    billing_email { "test@example.com" }
    openai_api_key { "sk12341817272818105" }
  end
end
