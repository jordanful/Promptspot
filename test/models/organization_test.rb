require "test_helper"

class OrganizationTest < ActiveSupport::TestCase

  test "should create organization" do
    FactoryBot.create(:organization)
    assert Organization.count == 1
  end

  test "should not create organization without billing_email" do
    assert_raises ActiveRecord::RecordInvalid do
      FactoryBot.create(:organization, billing_email: nil)
    end
  end
  
end
