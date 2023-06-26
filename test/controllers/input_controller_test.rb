require "test_helper"

class InputControllerTest < ActionDispatch::IntegrationTest

  setup do
    WebMock.allow_net_connect!
    VCR.insert_cassette name, {
      :allow_playback_repeats => true }
    @organization = FactoryBot.create(:organization)
    @account = FactoryBot.create(:account, organization: @organization)
    @user = FactoryBot.create(:user, account: @account)
    @input = FactoryBot.create(:input, account: @account, user: @user)
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
    get new_index_url
    assert_response :success
  end

  test "should create input" do
    assert_difference('Input.count') do
      post inputs_url, params: {
        input: {
          account_id: @account.id,
          text: "Example input text"
        }
      }
    end
  end

  test "should show prompt" do
    get input_url(input)
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
    assert_redirected_to input_path(@input)
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