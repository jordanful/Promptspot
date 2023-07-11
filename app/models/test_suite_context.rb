class TestSuiteContext < ApplicationRecord
  belongs_to :test_suite
  belongs_to :context
end
