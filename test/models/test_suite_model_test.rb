require "test_helper"

class TestSuiteModelTest < ActiveSupport::TestCase

  setup do
    VCR.insert_cassette name
    @organization = FactoryBot.create(:organization)
    @account = FactoryBot.create(:account, organization: @organization)
    @user = FactoryBot.create(:user, account: @account)
    model_provider = FactoryBot.create(:model_provider)
    @model = FactoryBot.create(:model, model_provider: model_provider)
    @prompt = FactoryBot.create(:prompt, account: @account)
    @prompt_version = FactoryBot.create(:prompt_version, prompt: @prompt, user: @user)
    @test_suite = FactoryBot.create(:test_suite, account: @account, user: @user)
  end

  teardown do
    VCR.eject_cassette
  end

  test "should create test suite model" do
    FactoryBot.create(:test_suite_model, test_suite: @test_suite, model: @model)
  end

  test "should not create test suite model without test suite" do
    assert_raises ActiveRecord::RecordInvalid do
      FactoryBot.create(:test_suite_model, test_suite: nil, model: @model)
    end
  end

  test "should not create test suite model without model" do
    assert_raises ActiveRecord::RecordInvalid do
      FactoryBot.create(:test_suite_model, test_suite: @test_suite, model: nil)
    end
  end
end
