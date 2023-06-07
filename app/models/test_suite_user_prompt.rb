class TestSuiteUserPrompt < ApplicationRecord
  belongs_to :test_suite
  belongs_to :user_prompt
end
