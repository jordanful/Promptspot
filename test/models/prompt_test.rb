require "test_helper"

class PromptTest < ActiveSupport::TestCase

  setup do
    WebMock.allow_net_connect!
    VCR.insert_cassette name
    @organization = FactoryBot.create(:organization)
    @account = FactoryBot.create(:account, organization: @organization)
    @user = FactoryBot.create(:user, account: @account)
  end

  teardown do
    VCR.eject_cassette
    WebMock.allow_net_connect!
  end

  test "should create prompt" do
    FactoryBot.create(:prompt, account: @account)
    assert Prompt.count == 1
  end

  test "should not create prompt without account" do
    assert_raises ActiveRecord::RecordInvalid do
      FactoryBot.create(:prompt, account: nil)
    end
  end

  test "should not create prompt without a title" do
    assert_raises ActiveRecord::RecordInvalid do
      FactoryBot.create(:prompt, title: nil)
    end
  end

  test "should not create prompt without a valid status" do
    assert_raises ActiveRecord::RecordInvalid do
      FactoryBot.create(:prompt, status: "invalid")
    end
  end

end
