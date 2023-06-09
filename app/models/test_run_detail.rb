class TestRunDetail < ApplicationRecord
  belongs_to :test_run
  belongs_to :prompt
  belongs_to :input
end
