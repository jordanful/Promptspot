require "test_helper"

class TestRunControllerTest < ActionDispatch::IntegrationTest

  setup do
    WebMock.allow_net_connect!
    VCR.insert_cassette name
    @user = FactoryBot.create(:user)
    @user.accounts.first.organization.update(openai_api_key: ENV["OPEN_AI_API_SECRET"])
    @prompt = FactoryBot.create(:prompt, account: @user.accounts.first)
    @prompt_version = FactoryBot.create(:prompt_version, prompt: @prompt, user: @user)
    @input = FactoryBot.create(:input, account: @user.accounts.first, user: @user)
    model_provider = FactoryBot.create(:model_provider)
    @model = FactoryBot.create(:model, model_provider: model_provider)
    @test_suite = FactoryBot.create(:test_suite, account: @user.accounts.first, user: @user)
    sign_in_as(@user)
  end

  teardown do
    VCR.eject_cassette
    WebMock.allow_net_connect!
  end

  test "should create test run" do
    assert_difference('TestRun.count') do
      post test_suite_test_runs_url(@test_suite)
    end
    assert_redirected_to test_suite_url(@test_suite)
  end

  test "should show test run" do
    @test_run = FactoryBot.create(:test_run, test_suite: @test_suite)
    FactoryBot.create(:test_run_detail, test_run: @test_run, prompt: @prompt, prompt_version: @prompt_version, input: @input)
    get test_suite_test_run_url(@test_suite, @test_run)
    assert_response :success
  end

  test "should destroy test run" do
    @test_run = FactoryBot.create(:test_run, test_suite: @test_suite)
    assert_difference('TestRun.count', -1) do
      delete test_suite_test_run_url(@test_suite, @test_run)
    end
    assert_redirected_to test_suite_url(@test_suite)
  end

  test "should archive test run" do
    @test_run = FactoryBot.create(:test_run, test_suite: @test_suite)
    post archive_test_suite_test_run_url(@test_suite, @test_run)
    assert_redirected_to test_suite_url(@test_suite)
    assert @test_run.reload.archived?
  end

  test "should unarchive test run" do
    @test_run = FactoryBot.create(:test_run, test_suite: @test_suite, archived: true)
    post unarchive_test_suite_test_run_url(@test_suite, @test_run)
    assert_redirected_to test_suite_url(@test_suite)
    assert_not @test_run.reload.archived?
  end

  test "should download test run" do
    @test_run = FactoryBot.create(:test_run, test_suite: @test_suite)
    get download_test_suite_test_run_url(@test_suite, @test_run)
    assert_response :success
  end

  test "should not create test run if no api key" do
    @user.accounts.first.organization.update!(openai_api_key: nil)
    assert_no_difference('TestRun.count') do
      post test_suite_test_runs_url(@test_suite)
    end
    assert_redirected_to test_suite_url(@test_suite)
  end

  test "should not create a test run for a different account" do
    sign_out_as(@user)
    user = FactoryBot.create(:user, email: "example3@test.com")
    sign_in_as(user)
    assert_no_difference('TestRun.count') do
      post test_suite_test_runs_url(@test_suite)
    end
  end

  test "should not show test run for a different account" do
    sign_out_as(@user)
    user = FactoryBot.create(:user, email: "example3@test.com")
    sign_in_as(user)
    @test_run = FactoryBot.create(:test_run, test_suite: @test_suite)
    FactoryBot.create(:test_run_detail, test_run: @test_run, prompt: @prompt, prompt_version: @prompt_version, input: @input)
    get test_suite_test_run_url(@test_suite, @test_run)
    assert_redirected_to root_url
  end

  test "should not download test run for a different account" do
    sign_out_as(@user)
    user = FactoryBot.create(:user, email: "example3@test.com")
    sign_in_as(user)
    @test_run = FactoryBot.create(:test_run, test_suite: @test_suite)
    get download_test_suite_test_run_url(@test_suite, @test_run)
    assert_redirected_to root_url
  end

  test "should not archive test run for a different account" do
    sign_out_as(@user)
    user = FactoryBot.create(:user, email: "example3@test.com")
    sign_in_as(user)
    @test_run = FactoryBot.create(:test_run, test_suite: @test_suite)
    post archive_test_suite_test_run_url(@test_suite, @test_run)
    assert_redirected_to root_url
  end

  test "should not unarchive test run for a different account" do
    sign_out_as(@user)
    user = FactoryBot.create(:user, email: "example3@test.com")
    sign_in_as(user)
    @test_run = FactoryBot.create(:test_run, test_suite: @test_suite, archived: true)
    post unarchive_test_suite_test_run_url(@test_suite, @test_run)
    assert_redirected_to root_url
  end

  test "should not destroy test run for a different account" do
    sign_out_as(@user)
    user = FactoryBot.create(:user, email: "example3@test.com")
    sign_in_as(user)
    @test_run = FactoryBot.create(:test_run, test_suite: @test_suite)
    assert_no_difference('TestRun.count') do
      delete test_suite_test_run_url(@test_suite, @test_run)
    end
  end

end