class TestSuitePrompt < ApplicationRecord
  belongs_to :test_suite
  belongs_to :prompt
end
