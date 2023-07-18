require "test_helper"

class PromptTest < ActiveSupport::TestCase

  setup do
    WebMock.allow_net_connect!
    VCR.insert_cassette name
    @user = FactoryBot.create(:user)
    @user.accounts.first.organization.update(openai_api_key: ENV["OPEN_AI_API_SECRET"])
  end

  teardown do
    VCR.eject_cassette
    WebMock.allow_net_connect!
  end

  test "should create prompt" do
    FactoryBot.create(:prompt, account: @user.accounts.first)
    assert Prompt.count == 1
  end

  test "should not create prompt without account" do
    assert_raises ActiveRecord::RecordInvalid do
      FactoryBot.create(:prompt, account: nil)
    end
  end

  test "should not create prompt without a valid status" do
    assert_raises ActiveRecord::RecordInvalid do
      FactoryBot.create(:prompt, status: "invalid")
    end
  end

end
