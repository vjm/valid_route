require 'test_helper'

class OthersControllerTest < ActionController::TestCase

  test "should get index" do
    @other = FactoryGirl.create(:other)
    get :index
    assert_response :success
    assert_not_nil assigns(:others)
  end

  test "should get new" do
    @other = Other.new
    get :new
    assert_response :success
  end

  test "should create other" do
    @other = FactoryGirl.build(:other)
    assert_difference('Other.count') do
      post :create, other: { content: @other.content, name: @other.name, permalink: @other.permalink }
    end

    assert_redirected_to other_path(assigns(:other))
  end

  test "should show other" do
    @other = FactoryGirl.create(:other)
    get :show, id: @other
    assert_response :success
  end

  test "should get edit" do
    @other = FactoryGirl.create(:other)
    get :edit, id: @other
    assert_response :success
  end

  test "should update other" do
    @other = FactoryGirl.create(:other)
    patch :update, id: @other, other: { content: @other.content, name: @other.name, permalink: @other.permalink }
    assert_redirected_to other_path(assigns(:other))
  end

  test "should destroy other" do
    @other = FactoryGirl.create(:other)
    assert_difference('Other.count', -1) do
      delete :destroy, id: @other
    end

    assert_redirected_to others_path
  end
end
