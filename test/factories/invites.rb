FactoryBot.define do
  factory :invite do
    inviter { nil }
    invitee { nil }
    account { nil }
    token { "MyString" }
    accepted { false }
  end
end
