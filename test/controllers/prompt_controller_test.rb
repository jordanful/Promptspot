require "test_helper"

class PromptControllerTest < ActionDispatch::IntegrationTest

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

  test "should get index" do
    get prompts_url
    assert_response :success
  end

  test "should get new" do
    get new_prompt_url
    assert_response :success
  end

  # TODO: Fix this test
  test "should create prompt" do
    assert_difference('Prompt.count') do
      post prompts_url, params: { prompt: { status: "active", account_id: @account.id, prompt_versions_attributes: [{ text: "Example prompt text" }] } }
    end
    puts response.body
    assert_redirected_to prompt_url(Prompt.last)
  end

  test "should show prompt" do
    get prompt_url(@prompt)
    assert_response :success
  end

  test "should get edit" do
    get edit_prompt_url(@prompt)
    assert_response :success
  end

  test "should update prompt" do
    patch prompt_url(@prompt), params: { prompt: { account_id: @account.id } }
    assert_redirected_to prompt_url(@prompt)
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