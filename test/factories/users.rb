FactoryBot.define do
  factory :user do
    email { "test@example.com" }
    password { "123456" }
    password_confirmation { "123456" }
    first_name { "John" }
    last_name { "Appleseed" }
  end
end
