require "test_helper"

class ModelProviderTest < ActiveSupport::TestCase
  test "should create model_provider" do
    FactoryBot.create(:model_provider)
    assert ModelProvider.count == 1
  end

  test "should not create model_provider without name" do
    assert_raises(ActiveRecord::RecordInvalid) do
      FactoryBot.create(:model_provider, name: nil)
    end
  end
end
