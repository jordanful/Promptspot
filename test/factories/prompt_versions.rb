FactoryBot.define do
  factory :prompt_version do
    prompt
    user
    text { "This is an example prompt" }
    version_number { 1 }
  end
end
