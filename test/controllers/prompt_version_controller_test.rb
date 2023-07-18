require "test_helper"

class PromptVersionControllerTest < ActionDispatch::IntegrationTest

  setup do
    WebMock.allow_net_connect!
    VCR.insert_cassette name
    @user = FactoryBot.create(:user)
    @user.accounts.first.organization.update(openai_api_key: ENV["OPEN_AI_API_SECRET"])
    @prompt = FactoryBot.create(:prompt, account: @user.accounts.first)
    sign_in_as(@user)
  end

  teardown do
    VCR.eject_cassette
    WebMock.allow_net_connect!
  end

  test "should show prompt version" do
    prompt_version = FactoryBot.create(:prompt_version, prompt: @prompt, text: "Example prompt text", user_id: @user.id)
    get prompt_version_url(prompt_id: @prompt.id, id: prompt_version.id,)
    assert_response :success
  end

end