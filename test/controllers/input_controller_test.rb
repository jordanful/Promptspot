require "test_helper"

class InputControllerTest < ActionDispatch::IntegrationTest

  setup do
    WebMock.allow_net_connect!
    VCR.insert_cassette name, {
      :allow_playback_repeats => true }
    @user = FactoryBot.create(:user)
    @user.accounts.first.organization.update(openai_api_key: ENV["OPEN_AI_API_SECRET"])
    @input = FactoryBot.create(:input, account: @user.accounts.first, user: @user)
    sign_in_as(@user)
  end

  teardown do
    VCR.eject_cassette
    WebMock.allow_net_connect!
  end

  test "should get index" do
    get inputs_url
    assert_response :success
  end

  test "should get new" do
    get new_input_url
    assert_response :success
  end

  test "should create input" do
    assert_difference('Input.count') do
      post inputs_url, params: {
        input: {
          account_id: @user.accounts.first.id,
          text: "Example input text"
        }
      }
    end
  end

  test "should show prompt" do
    get input_url(@input)
    assert_response :success
  end

  test "should get edit" do
    get edit_input_url(@input)
    assert_response :success
  end

  test "should update input" do
    patch input_url(@input), params: {
      input: {
        text: "This is an updated input",
      }
    }
    assert_redirected_to inputs_path
    @input.reload
    assert_equal "This is an updated input", @input.text
  end

  test "should destroy input" do
    assert_difference('Input.count', -1) do
      delete input_url(@input)
    end
    assert_redirected_to inputs_path
  end

end