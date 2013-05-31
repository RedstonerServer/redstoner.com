require 'test_helper'

class BlogpostsControllerTest < ActionController::TestCase
  setup do
    @blogpost = blogposts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:blogposts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create blogpost" do
    assert_difference('Blogpost.count') do
      post :create, blogpost: {  }
    end

    assert_redirected_to blogpost_path(assigns(:blogpost))
  end

  test "should show blogpost" do
    get :show, id: @blogpost
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @blogpost
    assert_response :success
  end

  test "should update blogpost" do
    put :update, id: @blogpost, blogpost: {  }
    assert_redirected_to blogpost_path(assigns(:blogpost))
  end

  test "should destroy blogpost" do
    assert_difference('Blogpost.count', -1) do
      delete :destroy, id: @blogpost
    end

    assert_redirected_to blogposts_path
  end
end
