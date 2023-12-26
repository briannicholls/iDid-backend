require 'test_helper'

class API::V1::CountersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @counter = counters(:one)
  end

  test 'should get index' do
    get api_v1_counters_url
    assert_response :success
  end

  test 'should create counter' do
    assert_difference('Counter.count') do
      post api_v1_counters_url,
           params: { counter: { name: 'Test Counter', dimension: 'default', measurement_unit: nil,
                                track_reps: true } }
    end

    assert_response :created
  end

  test 'should not create counter with invalid data' do
    assert_no_difference('Counter.count') do
      post api_v1_counters_url,
           params: { counter: { name: '', dimension: 'default', measurement_unit: 'unit', track_reps: true } }
    end

    assert_response :unprocessable_entity
  end

  test 'should get leaders' do
    get leaders_api_v1_counters_url
    assert_response :success
  end

  private

  def counters_url
    '/api/v1/counters'
  end

  def leaders_url
    '/api/v1/counters/leaders'
  end
end
