require "test_helper"

class PromptVersionTest < ActiveSupport::TestCase

  setup do
    WebMock.allow_net_connect!
    VCR.insert_cassette name
    @organization = FactoryBot.create(:organization)
    @account = FactoryBot.create(:account, organization: @organization)
    @user = FactoryBot.create(:user, account: @account)
    @prompt = FactoryBot.create(:prompt, account: @account)
  end

  teardown do
    VCR.eject_cassette
    WebMock.allow_net_connect!
  end

  test "should create prompt version" do
    FactoryBot.create(:prompt_version, prompt: @prompt, user: @user)
    assert PromptVersion.count == 1
  end

  test "should not create prompt version without prompt" do
    assert_raises ActiveRecord::RecordInvalid do
      FactoryBot.create(:prompt_version, prompt: nil, user: @user)
    end
  end

  test "should not create prompt version without user" do
    assert_raises ActiveRecord::RecordInvalid do
      FactoryBot.create(:prompt_version, prompt: @prompt, user: nil)
    end
  end

  test "should not create prompt version without a version number" do
    assert_raises ActiveRecord::RecordInvalid do
      FactoryBot.create(:prompt_version, prompt: @prompt, user: @user, version_number: nil)
    end
  end

  test "should not create prompt version without text" do
    assert_raises ActiveRecord::RecordInvalid do
      FactoryBot.create(:prompt_version, prompt: @prompt, user: @user, text: nil)
    end
  end

end
