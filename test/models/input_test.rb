require "test_helper"

class InputTest < ActiveSupport::TestCase
  setup do
    WebMock.allow_net_connect!
    VCR.insert_cassette name
    @user = FactoryBot.create(:user)
    @user.accounts.first.organization.update(openai_api_key: ENV["OPEN_AI_API_SECRET"])
  end

  teardown do
    VCR.eject_cassette
    WebMock.allow_net_connect!
  end

  def test_should_create_input
    FactoryBot.create(:input, user_id: @user.id, account_id: @user.accounts.first.id)
    assert Input.count == 1
  end

  def test_should_not_create_input_without_user_id
    assert_raises(ActiveRecord::RecordInvalid) do
      FactoryBot.create(:input, account_id: @user.accounts.first.id)
    end
  end

  def test_should_not_create_input_without_account_id
    assert_raises(ActiveRecord::RecordInvalid) do
      FactoryBot.create(:input, user_id: @user.id, account: nil)
    end
  end

  def test_should_not_create_input_without_text
    assert_raises(ActiveRecord::RecordInvalid) do
      FactoryBot.create(:input, user_id: @user.id, account_id: @user.accounts.first.id, text: nil)
    end
  end

end
