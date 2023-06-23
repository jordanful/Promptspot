require "test_helper"

class PromptVersionControllerTest < ActionDispatch::IntegrationTest

  setup do
    WebMock.allow_net_connect!
    VCR.insert_cassette name
    @organization = FactoryBot.create(:organization)
    @account = FactoryBot.create(:account, organization: @organization)
    @user = FactoryBot.create(:user, account: @account)
    @prompt = FactoryBot.create(:prompt, account: @account)
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