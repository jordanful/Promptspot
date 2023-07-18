require "test_helper"

class TestSuiteTest < ActiveSupport::TestCase
  setup do
    WebMock.allow_net_connect!
    VCR.insert_cassette name
    @user = FactoryBot.create(:user)
    @user.accounts.first.organization.update(openai_api_key: ENV["OPEN_AI_API_SECRET"])
    model_provider = FactoryBot.create(:model_provider)
    @model = FactoryBot.create(:model, model_provider: model_provider)
    @prompt = FactoryBot.create(:prompt, account: @user.accounts.first)
    @prompt_version = FactoryBot.create(:prompt_version, prompt: @prompt, user: @user)
    @input = FactoryBot.create(:input, account: @user.accounts.first, user: @user)
  end

  teardown do
    VCR.eject_cassette
    WebMock.allow_net_connect!
  end

  test "should create test suite" do
    FactoryBot.create(:test_suite, account: @user.accounts.first, user: @user)
  end

  test "should not create test suite without account" do
    assert_raises ActiveRecord::RecordInvalid do
      FactoryBot.create(:test_suite, account: nil, user: @user)
    end
  end

  test "should not create test suite without user" do
    assert_raises ActiveRecord::RecordInvalid do
      FactoryBot.create(:test_suite, account: @user.accounts.first, user: nil)
    end
  end

  test "should not create test suite without name" do
    assert_raises ActiveRecord::RecordInvalid do
      FactoryBot.create(:test_suite, account: @user.accounts.first, user: @user, name: nil)
    end
  end

  test "should not create test suite without mode" do
    assert_raises ActiveRecord::RecordInvalid do
      FactoryBot.create(:test_suite, account: @user.accounts.first, user: @user, mode: nil)
    end
  end

end
