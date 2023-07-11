require "test_helper"

class ContextControllerTest < ActionDispatch::IntegrationTest

  setup do
    WebMock.allow_net_connect!
    VCR.insert_cassette name, {
      :allow_playback_repeats => true }
    @organization = FactoryBot.create(:organization)
    @account = FactoryBot.create(:account, organization: @organization)
    @user = FactoryBot.create(:user, account: @account)
    @context = FactoryBot.create(:context, account: @account, user: @user)
    sign_in_as(@user)
  end

  teardown do
    VCR.eject_cassette
    WebMock.allow_net_connect!
  end

  test "should get index" do
    get contexts_url
    assert_response :success
  end

  test "should get new" do
    get new_context_url
    assert_response :success
  end

  test "should create context" do
    assert_difference('Context.count') do
      post contexts_url, params: {
        context: {
          account_id: @account.id,
          text: "Example context"
        }
      }
    end
  end

  test "should show prompt" do
    get context_url(@context)
    assert_response :success
  end

  test "should get edit" do
    get edit_context_url(@context)
    assert_response :success
  end

  test "should update context" do
    patch context_url(@context), params: {
      context: {
        text: "This is an updated context",
      }
    }
    assert_redirected_to contexts_path
    @context.reload
    assert_equal "This is an updated context", @context.text
  end

  test "should destroy context" do
    assert_difference('Context.count', -1) do
      delete context_url(@context)
    end
    assert_redirected_to contexts_path
  end

end