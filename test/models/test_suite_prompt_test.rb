require "test_helper"

class TestSuitePromptTest < ActiveSupport::TestCase
  setup do
    WebMock.allow_net_connect!
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
    WebMock.allow_net_connect!
  end

  test "should create test suite prompt" do
    FactoryBot.create(:test_suite_prompt, test_suite: @test_suite, prompt: @prompt)
  end

  test "should not create test suite prompt without test suite" do
    assert_raises ActiveRecord::RecordInvalid do
      FactoryBot.create(:test_suite_prompt, test_suite: nil, prompt: @prompt)
    end
  end

  test "should not create test suite prompt without prompt" do
    assert_raises ActiveRecord::RecordInvalid do
      FactoryBot.create(:test_suite_prompt, test_suite: @test_suite, prompt: nil)
    end
  end

end
