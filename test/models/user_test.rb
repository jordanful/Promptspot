require "test_helper"

class UserTest < ActiveSupport::TestCase

  test "should create user" do
    FactoryBot.create(:user)
    assert User.count == 1
  end

  test "should not create user without email" do
    assert_raises ActiveRecord::RecordInvalid do
      FactoryBot.create(:user, email: nil)
    end
  end

  test "should not create user without password" do
    assert_raises ActiveRecord::RecordInvalid do
      FactoryBot.create(:user, password: nil)
    end
  end

end
