require "test_helper"

class TestSuiteTest < ActiveSupport::TestCase
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
  end

  teardown do
    VCR.eject_cassette
    WebMock.allow_net_connect!
  end

  test "should create test suite" do
    FactoryBot.create(:test_suite, account: @account, user: @user)
  end

  test "should not create test suite without account" do
    assert_raises ActiveRecord::RecordInvalid do
      FactoryBot.create(:test_suite, account: nil, user: @user)
    end
  end

  test "should not create test suite without user" do
    assert_raises ActiveRecord::RecordInvalid do
      FactoryBot.create(:test_suite, account: @account, user: nil)
    end
  end

  test "should not create test suite without name" do
    assert_raises ActiveRecord::RecordInvalid do
      FactoryBot.create(:test_suite, account: @account, user: @user, name: nil)
    end
  end

  test "should not create test suite without mode" do
    assert_raises ActiveRecord::RecordInvalid do
      FactoryBot.create(:test_suite, account: @account, user: @user, mode: nil)
    end
  end

end
