require 'test_helper'

class BangDiemControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get bang_diem_index_url
    assert_response :success
  end

end
