class TestRun < ApplicationRecord
  belongs_to :test_suite
  has_many :test_run_details
end
