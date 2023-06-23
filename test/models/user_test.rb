require "test_helper"

class UserTest < ActiveSupport::TestCase
  setup do
    @organization = FactoryBot.create(:organization)
    @account = FactoryBot.create(:account, organization: @organization)
  end

  test "should create user" do
    FactoryBot.create(:user, account: @account)
  end

  test "should not create user without email" do
    assert_raises ActiveRecord::RecordInvalid do
      FactoryBot.create(:user, account: @account, email: nil)
    end
  end

  test "should not create user without password" do
    assert_raises ActiveRecord::RecordInvalid do
      FactoryBot.create(:user, account: @account, password: nil)
    end
  end

end
