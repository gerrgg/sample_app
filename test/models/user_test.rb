require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: 'foobar', password_confirmation: 'foobar')
  end

  test 'should be valid' do
    assert @user.valid?
  end

  test 'name should be present' do
    @user.name = ''
    assert_not @user.valid?
  end

  test 'email should be present' do
    @user.email = ''
    assert_not @user.valid?
  end

  test 'name should not be over 50 characters' do
    @user.name = 'a'*51
    assert_not @user.valid?
  end

  test 'email should not be over 255 characters' do
    @user.email = 'a' * 244 + '@example.com'
    assert_not @user.valid?
  end

  test 'email validation' do
    valid_addresses = %w[user@example.com USER@foo.COM 
      A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    
    valid_addresses.each do |address|
      @user.email = address
      assert @user.valid? "#{address.inspect} should be valid"
    end
  end

  test 'password should not be blank' do
    @user.password = @user.password_confirmation = '       '
    assert_not @user.valid?
  end

  test 'password should be atleast 6 characters' do
    @user.password = @user.password_confirmation = 'a' * 5
    assert_not @user.valid?
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com foo@bar..com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test 'email should be unique' do
    dupe_user = @user.dup
    dupe_user.email = @user.email.upcase
    @user.save
    assert_not dupe_user.valid?
  end

  test 'email should equal self.downcase' do
    mixed_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_email
    @user.save
    assert_equal mixed_email.downcase, @user.reload.email
  end

  test 'authenticated? should return false for a user with a nil digest' do
    assert_not @user.authenticated?(:remember, '')
  end

end
