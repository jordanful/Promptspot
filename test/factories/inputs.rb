FactoryBot.define do
  factory :input do
    text { "User profile:
Name: Alice Lee
Age: 29
Favorite hotels: 1) Ace Hotel in New Orleans, 2) Hotel San Fernando in Mexico City, 3) Blackberry Farms in TN
Hobbies and interests: fitness, art museums, music festivals" }
    account_id { SecureRandom.uuid }
    user_id { SecureRandom.uuid }
    
  end
end
