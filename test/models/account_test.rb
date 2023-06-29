require "test_helper"

class AccountTest < ActiveSupport::TestCase
  setup do
    @organization = FactoryBot.create(:organization)
  end

  test "should create account" do
    FactoryBot.create(:account, organization_id: @organization.id)
    assert Account.count == 1
  end

  test "should not create account without organization_id" do
    assert_raises(ActiveRecord::RecordInvalid) do
      FactoryBot.create(:account, organization: nil)
    end
  end

end
