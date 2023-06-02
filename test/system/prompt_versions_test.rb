require "application_system_test_case"

class PromptVersionsTest < ApplicationSystemTestCase
  setup do
    @prompt_version = prompt_versions(:one)
  end

  test "visiting the index" do
    visit prompt_versions_url
    assert_selector "h1", text: "Prompt versions"
  end

  test "should create prompt version" do
    visit prompt_versions_url
    click_on "New prompt version"

    fill_in "Prompt", with: @prompt_version.prompt_id
    fill_in "Text", with: @prompt_version.text
    fill_in "User", with: @prompt_version.user_id
    click_on "Create Prompt version"

    assert_text "Prompt version was successfully created"
    click_on "Back"
  end

  test "should update Prompt version" do
    visit prompt_version_url(@prompt_version)
    click_on "Edit this prompt version", match: :first

    fill_in "Prompt", with: @prompt_version.prompt_id
    fill_in "Text", with: @prompt_version.text
    fill_in "User", with: @prompt_version.user_id
    click_on "Update Prompt version"

    assert_text "Prompt version was successfully updated"
    click_on "Back"
  end

  test "should destroy Prompt version" do
    visit prompt_version_url(@prompt_version)
    click_on "Destroy this prompt version", match: :first

    assert_text "Prompt version was successfully destroyed"
  end
end
