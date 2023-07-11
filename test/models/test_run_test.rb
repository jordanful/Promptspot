require "test_helper"

class TestRunTest < ActiveSupport::TestCase
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

  test "should create test run" do
    FactoryBot.create(:test_run, test_suite: @test_suite)
    assert TestRun.count == 1
  end

  test "should not create test run without test suite" do
    assert_raises ActiveRecord::RecordInvalid do
      FactoryBot.create(:test_run, test_suite: nil)
    end
  end

  test "should not create test run without an archived flag" do
    assert_raises ActiveRecord::RecordInvalid do
      FactoryBot.create(:test_run, test_suite: @test_suite, archived: nil)
    end
  end

end
