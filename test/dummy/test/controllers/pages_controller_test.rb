require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  setup do
    @page = FactoryGirl.create(:page)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:pages)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create page" do
    @built_page = FactoryGirl.build(:page)
    assert_difference('Page.count') do
      post :create, page: { content: @built_page.content, name: @built_page.name, permalink: @built_page.permalink }
    end

    assert_redirected_to page_path(assigns(:page))
  end

  test "should show page" do
    get :show, id: @page
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @page
    assert_response :success
  end

  test "should update page" do
    patch :update, id: @page, page: { content: @page.content, name: @page.name, permalink: @page.permalink }
    assert_redirected_to page_path(assigns(:page))
  end

  test "should destroy page" do
    assert @page.save
    assert_difference('Page.count', -1) do
      delete :destroy, id: @page
    end

    assert_redirected_to pages_path
  end
end
