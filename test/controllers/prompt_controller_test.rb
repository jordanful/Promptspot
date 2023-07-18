require "test_helper"

class PromptControllerTest < ActionDispatch::IntegrationTest

  setup do
    WebMock.allow_net_connect!
    VCR.insert_cassette name, {
      :allow_playback_repeats => true }
    @user = FactoryBot.create(:user)
    @user.accounts.first.organization.update(openai_api_key: ENV["OPEN_AI_API_SECRET"])
    @prompt = FactoryBot.create(:prompt, account: @user.accounts.first)
    sign_in_as(@user)
  end

  teardown do
    VCR.eject_cassette
    WebMock.allow_net_connect!
  end

  test "should get index" do
    FactoryBot.create(:prompt_version, prompt: @prompt, text: "Example prompt text", user_id: @user.id)
    get prompts_url
    assert_response :success
  end

  test "should get new" do
    get new_prompt_url
    assert_response :success
  end

  test "should create prompt" do
    assert_difference('Prompt.count') do
      post prompts_url, params: {
        prompt: {
          status: "active",
          account_id: @user.accounts.first.id,
          prompt_versions_attributes: [{ text: "Example prompt text 2" }]
        }
      }
    end
  end

  test "should show prompt" do
    FactoryBot.create(:prompt_version, prompt: @prompt, text: "Example prompt text", user_id: @user.id)
    get prompt_url(@prompt)
    assert_response :success
  end

  test "should get edit" do
    FactoryBot.create(:prompt_version, prompt: @prompt, text: "Example prompt text", user_id: @user.id)
    get edit_prompt_url(@prompt)
    assert_response :success
  end

  test "should update prompt" do
    FactoryBot.create(:prompt_version, prompt: @prompt, text: "Example prompt text", user_id: @user.id)
    patch prompt_url(@prompt), params: {
      prompt: {
        status: "archived",
        prompt_versions_attributes: {
          '0' => { text: "Updated prompt text" }
        }
      }
    }
    assert_redirected_to prompt_path(@prompt)
    @prompt.reload
    assert_equal "archived", @prompt.status
    assert_equal "Updated prompt text", @prompt.prompt_versions.order(version_number: :desc).first.text
  end

  test "should archive prompt" do

    post archive_prompt_url(@prompt), params: { prompt: { status: "archived" } }
    assert_redirected_to prompts_url
  end

  test "should unarchive prompt" do
    post unarchive_prompt_url(@prompt), params: { prompt: { status: "active" } }
    assert_redirected_to prompt_path(@prompt)
  end

end