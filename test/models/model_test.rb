require "test_helper"

class ModelTest < ActiveSupport::TestCase

  setup do
    @provider = FactoryBot.create(:model_provider)
  end

  test "should create model" do
    FactoryBot.create(:model, model_provider_id: @provider.id)
    assert Model.count == 1
  end

  test "should not create model without model_provider_id" do
    assert_raises ActiveRecord::RecordInvalid do
      FactoryBot.create(:model, model_provider_id: nil)
    end
  end

  test "should not create model without name" do
    assert_raises ActiveRecord::RecordInvalid do
      FactoryBot.create(:model, name: nil)
    end
  end

  test "should not create model without enabled" do
    assert_raises ActiveRecord::RecordInvalid do
      FactoryBot.create(:model, enabled: nil)
    end
  end
  
  test "should not create model without model_type" do
    assert_raises ActiveRecord::RecordInvalid do
      FactoryBot.create(:model, model_type: nil)
    end
  end

  test "should not create model with invalid model_type" do
    assert_raises ActiveRecord::RecordInvalid do
      FactoryBot.create(:model, model_type: "invalid")
    end
  end

  test "should not create model with invalid model_provider_id" do
    assert_raises ActiveRecord::RecordInvalid do
      FactoryBot.create(:model, model_provider_id: "invalid")
    end
  end

end
