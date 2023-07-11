class TestRunModel < ApplicationRecord
  belongs_to :test_run
  belongs_to :model
end
