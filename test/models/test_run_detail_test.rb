require "test_helper"

class TestRunDetailTest < ActiveSupport::TestCase
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
    @context = FactoryBot.create(:context, account: @account, user: @user)
    @test_suite = FactoryBot.create(:test_suite, account: @account, user: @user)
    @test_run = FactoryBot.create(:test_run, test_suite: @test_suite)
  end

  teardown do
    VCR.eject_cassette
    WebMock.allow_net_connect!
  end

  test "should create test run detail" do
    FactoryBot.create(:test_run_detail, test_run: @test_run, context: @context, prompt: @prompt, prompt_version: @prompt_version, model: @model)
    assert TestRunDetail.count == 1
  end

  test "should not create test run detail without test run" do
    assert_raises ActiveRecord::RecordInvalid do
      FactoryBot.create(:test_run_detail, test_run: nil, context: @context, prompt: @prompt, prompt_version: @prompt_version, model: @model)
    end
  end

  test "should not create test run detail without context" do
    assert_raises ActiveRecord::RecordInvalid do
      FactoryBot.create(:test_run_detail, test_run: @test_run, context: nil, prompt: @prompt, prompt_version: @prompt_version, model: @model)
    end
  end

  test "should not create test run detail without prompt" do
    assert_raises ActiveRecord::RecordInvalid do
      FactoryBot.create(:test_run_detail, test_run: @test_run, context: @context, prompt: nil, prompt_version: @prompt_version, model: @model)
    end
  end

  test "should not create test run detail without prompt version" do
    assert_raises ActiveRecord::RecordInvalid do
      FactoryBot.create(:test_run_detail, test_run: @test_run, context: @context, prompt: @prompt, prompt_version: nil, model: @model)
    end
  end

  test "should not create test run detail without model" do
    assert_raises ActiveRecord::RecordInvalid do
      FactoryBot.create(:test_run_detail, test_run: @test_run, context: @context, prompt: @prompt, prompt_version: @prompt_version, model: nil)
    end
  end

end
