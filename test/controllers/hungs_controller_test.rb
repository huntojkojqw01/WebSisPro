require 'test_helper'

class HungsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @hung = hungs(:one)
  end

  test "should get index" do
    get hungs_url
    assert_response :success
  end

  test "should get new" do
    get new_hung_url
    assert_response :success
  end

  test "should create hung" do
    assert_difference('Hung.count') do
      post hungs_url, params: { hung: {  } }
    end

    assert_redirected_to hung_url(Hung.last)
  end

  test "should show hung" do
    get hung_url(@hung)
    assert_response :success
  end

  test "should get edit" do
    get edit_hung_url(@hung)
    assert_response :success
  end

  test "should update hung" do
    patch hung_url(@hung), params: { hung: {  } }
    assert_redirected_to hung_url(@hung)
  end

  test "should destroy hung" do
    assert_difference('Hung.count', -1) do
      delete hung_url(@hung)
    end

    assert_redirected_to hungs_url
  end
end
