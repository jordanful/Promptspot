FactoryBot.define do
  factory :user do
    email { "test@example.com" }
    account_id { SecureRandom.uuid }
    encrypted_password { "123456" }
    password { "123456" }
    first_name { "John" }
    last_name { "Appleseed" }
  end
end
