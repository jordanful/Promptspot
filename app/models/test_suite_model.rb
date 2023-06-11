class TestSuiteModel < ApplicationRecord
  belongs_to :test_suite
  belongs_to :model
end
