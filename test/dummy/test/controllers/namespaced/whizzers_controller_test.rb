require 'test_helper'

module Namespaced
  class WhizzersControllerTest < ActionController::TestCase
    setup do
      @namespaced_whizzer = FactoryGirl.create(:namespaced_whizzer)
    end

    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:namespaced_whizzers)
    end

    test "should get new" do
      get :new
      assert_response :success
    end

    test "should create namespaced_whizzer" do
      assert_difference('Namespaced::Whizzer.count') do
        post :create, namespaced_whizzer: { permalink: @namespaced_whizzer.permalink }
      end

      assert_redirected_to namespaced_whizzer_path(assigns(:namespaced_whizzer))
    end

    test "should show namespaced_whizzer" do
      get :show, id: @namespaced_whizzer
      assert_response :success
    end

    test "should get edit" do
      get :edit, id: @namespaced_whizzer
      assert_response :success
    end

    test "should update namespaced_whizzer" do
      patch :update, id: @namespaced_whizzer, namespaced_whizzer: { permalink: @namespaced_whizzer.permalink }
      assert_redirected_to namespaced_whizzer_path(assigns(:namespaced_whizzer))
    end

    test "should destroy namespaced_whizzer" do
      assert_difference('Namespaced::Whizzer.count', -1) do
        delete :destroy, id: @namespaced_whizzer
      end

      assert_redirected_to namespaced_whizzers_path
    end
  end
end