require "test_helper"

class TestSuiteControllerTest < ActionDispatch::IntegrationTest

  setup do
    WebMock.allow_net_connect!
    VCR.insert_cassette name
    @user = FactoryBot.create(:user)
    @user.accounts.first.organization.update(openai_api_key: ENV["OPEN_AI_API_SECRET"])
    @test_suite = FactoryBot.create(:test_suite, account: @user.accounts.first, user: @user)
    sign_in_as(@user)
  end

  teardown do
    VCR.eject_cassette
    WebMock.allow_net_connect!
  end

  test "should get index" do
    get test_suites_url
    assert_response :success
  end

  test "should get new" do
    get new_test_suite_url
    assert_response :success
  end

  test "should get edit" do
    get edit_test_suite_url(@test_suite)
    assert_response :success
  end

  test "should show test suite" do
    get test_suite_url(@test_suite)
    assert_response :success
  end

  test "should destroy test suite" do
    assert_difference("TestSuite.count", -1) do
      delete test_suite_url(@test_suite)
    end

    assert_redirected_to test_suites_url
  end

  test "should archive test suite" do
    post archive_test_suite_url(@test_suite)
    assert_response :redirect
    assert @test_suite.reload.archived?
  end

  test "should not archive test suite of a different account" do
    sign_out_as(@user)
    user = FactoryBot.create(:user, email: "thearchiver@example.com")
    sign_in_as(user)
    post archive_test_suite_url(@test_suite)
    assert_response :redirect
    assert_not @test_suite.reload.archived?

  end
  test "should not edit test suite of a different account" do
    sign_out_as(@user)
    user = FactoryBot.create(:user, email: "example3@test.com")
    sign_in_as(user)
    get edit_test_suite_url(@test_suite)
    assert_response :redirect
  end

  test "should update test suite" do
    patch test_suite_url(@test_suite), params: { test_suite: { name: "Updated test suite" } }
    assert_response :redirect
    assert_redirected_to edit_test_suite_url(@test_suite)
  end

  test "should not show test suite of a different account" do
    sign_out_as(@user)
    user = FactoryBot.create(:user, email: "example2@test.com")
    sign_in_as(user)
    get test_suite_url(@test_suite)
    assert_response :redirect
  end

  test "should not update test suite of a different account" do
    sign_out_as(@user)

    user = FactoryBot.create(:user, email: "example4@test.com")
    sign_in_as(user)
    patch test_suite_url(@test_suite), params: { test_suite: { name: "Updated test suite2" } }
    assert_response :redirect
    assert @test_suite.reload.name != "Updated test suite2"
  end

  test "should not destroy test suite of a different account" do
    user = FactoryBot.create(:user, email: "destroyer@test.com")
    test_suite = FactoryBot.create(:test_suite, account: user.accounts.first, user: user)
    delete test_suite_url(test_suite)
    assert_response :redirect
  end

end
