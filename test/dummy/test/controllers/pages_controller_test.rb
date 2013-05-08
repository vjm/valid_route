require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:pages)
  end

  test "should get new" do
    @page = Page.new
    get :new
    assert_response :success
  end

  test "should create page" do
    @built_page = FactoryGirl.build(:page)
    assert @built_page.valid?, @built_page.inspect
    assert_difference('Page.count') do
      post :create, page: { content: @built_page.content, name: @built_page.name, permalink: @built_page.permalink }
    end

    assert_redirected_to page_path(assigns(:page))
  end

  test "should show page" do
    @page = FactoryGirl.create(:page)

    get :show, id: @page
    assert_response :success
  end

  test "should get edit" do
    @page = FactoryGirl.create(:page)
    get :edit, id: @page
    assert_response :success
  end

  test "should update page" do
    @page = FactoryGirl.create(:page)

    patch :update, id: @page, page: { content: @page.content, name: @page.name, permalink: @page.permalink }
    assert_redirected_to page_path(assigns(:page))
  end

  test "should destroy page" do
    @page = FactoryGirl.create(:page)
    assert_difference('Page.count', -1) do
      delete :destroy, id: @page
    end

    assert_redirected_to pages_path
  end
end
