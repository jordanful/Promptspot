require "test_helper"

class PromptVersionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @prompt_version = prompt_versions(:one)
  end

  test "should get index" do
    get prompt_versions_url
    assert_response :success
  end

  test "should get new" do
    get new_prompt_version_url
    assert_response :success
  end

  test "should create prompt_version" do
    assert_difference("PromptVersion.count") do
      post prompt_versions_url, params: { prompt_version: { prompt_id: @prompt_version.prompt_id, text: @prompt_version.text, user_id: @prompt_version.user_id } }
    end

    assert_redirected_to prompt_version_url(PromptVersion.last)
  end

  test "should show prompt_version" do
    get prompt_version_url(@prompt_version)
    assert_response :success
  end

  test "should get edit" do
    get edit_prompt_version_url(@prompt_version)
    assert_response :success
  end

  test "should update prompt_version" do
    patch prompt_version_url(@prompt_version), params: { prompt_version: { prompt_id: @prompt_version.prompt_id, text: @prompt_version.text, user_id: @prompt_version.user_id } }
    assert_redirected_to prompt_version_url(@prompt_version)
  end

  test "should destroy prompt_version" do
    assert_difference("PromptVersion.count", -1) do
      delete prompt_version_url(@prompt_version)
    end

    assert_redirected_to prompt_versions_url
  end
end
