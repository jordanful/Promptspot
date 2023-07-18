require "test_helper"

class PromptVersionTest < ActiveSupport::TestCase

  setup do
    WebMock.allow_net_connect!
    VCR.insert_cassette name
    @user = FactoryBot.create(:user)
    @user.accounts.first.organization.update(openai_api_key: ENV["OPEN_AI_API_SECRET"])
    @prompt = FactoryBot.create(:prompt, account: @user.accounts.first)
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

  test "should autogenerate prompt title" do
    prompt_version = FactoryBot.create(:prompt_version, prompt: @prompt, user: @user)
    assert prompt_version.prompt.title == @prompt.title
  end

  test "should not autogenerate prompt title if version number is not 1" do
    FactoryBot.create(:prompt_version, prompt: @prompt, user: @user)
    title = @prompt.title
    FactoryBot.create(:prompt_version, prompt: @prompt, user: @user)
    assert @prompt.title == title
  end
end
