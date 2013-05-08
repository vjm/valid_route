require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should get new" do
    @user = User.new
    get :new
    assert_response :success
  end

  test "should create user" do
    @user = FactoryGirl.build(:user)
    assert_difference('User.count') do
      post :create, user: { first_name: @user.first_name, password: @user.password, username: @user.username }
    end

    assert_redirected_to user_path(assigns(:user))
  end

  test "should show user" do
    @user = FactoryGirl.create(:user)
    get :show, id: @user
    assert_response :success
  end

  test "should get edit" do
    @user = FactoryGirl.create(:user)
    get :edit, id: @user
    assert_response :success
  end

  test "should update user" do
    @user = FactoryGirl.create(:user)
    patch :update, id: @user, user: { first_name: @user.first_name, password: @user.password, username: @user.username }
    assert_redirected_to user_path(assigns(:user))
  end

  test "should destroy user" do
    @user = FactoryGirl.create(:user)
    assert_difference('User.count', -1) do
      delete :destroy, id: @user
    end

    assert_redirected_to users_path
  end
end
