require "test_helper"

class InputTest < ActiveSupport::TestCase
  setup do
    WebMock.allow_net_connect!
    VCR.insert_cassette name
    @organization = FactoryBot.create(:organization)
    @account = FactoryBot.create(:account, organization_id: @organization.id)
    @user = FactoryBot.create(:user, account_id: @account.id)
  end

  teardown do
    VCR.eject_cassette
    WebMock.allow_net_connect!
  end

  def test_should_create_input
    FactoryBot.create(:input, user_id: @user.id, account_id: @account.id)
    assert Input.count == 1
  end

  def test_should_not_create_input_without_user_id
    assert_raises(ActiveRecord::RecordInvalid) do
      FactoryBot.create(:input, account_id: @account.id)
    end
  end

  def test_should_not_create_input_without_account_id
    assert_raises(ActiveRecord::RecordInvalid) do
      FactoryBot.create(:input, user_id: @user.id)
    end
  end

  def test_should_not_create_input_without_text
    assert_raises(ActiveRecord::RecordInvalid) do
      FactoryBot.create(:input, user_id: @user.id, account_id: @account.id, text: nil)
    end
  end

end
