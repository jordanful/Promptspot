require "test_helper"

class ContextTest < ActiveSupport::TestCase
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

  def test_should_create_context
    FactoryBot.create(:context, user_id: @user.id, account_id: @account.id)
    assert Context.count == 1
  end

  def test_should_not_create_context_without_user_id
    assert_raises(ActiveRecord::RecordInvalid) do
      FactoryBot.create(:context, account_id: @account.id)
    end
  end

  def test_should_not_create_context_without_account_id
    assert_raises(ActiveRecord::RecordInvalid) do
      FactoryBot.create(:context, user_id: @user.id, account: nil)
    end
  end

  def test_should_not_create_context_without_text
    assert_raises(ActiveRecord::RecordInvalid) do
      FactoryBot.create(:context, user_id: @user.id, account_id: @account.id, text: nil)
    end
  end

end
