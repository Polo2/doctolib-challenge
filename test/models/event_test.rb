require 'test_helper'

class EventTest < ActiveSupport::TestCase


  test "simple test exemple from specs" do

    Event.create kind: 'opening', starts_at: DateTime.parse("2014-08-04 09:30"), ends_at: DateTime.parse("2014-08-04 12:30"), weekly_recurring: true
    Event.create kind: 'appointment', starts_at: DateTime.parse("2014-08-11 10:30"), ends_at: DateTime.parse("2014-08-11 11:30")

    availabilities = Event.availabilities DateTime.parse("2014-08-10")
    assert_equal Date.new(2014, 8, 10), availabilities[0][:date]
    assert_equal [], availabilities[0][:slots]
    assert_equal Date.new(2014, 8, 11), availabilities[1][:date]
    assert_equal ["9:30", "10:00", "11:30", "12:00"], availabilities[1][:slots]
    assert_equal Date.new(2014, 8, 16), availabilities[6][:date]
    assert_equal 7, availabilities.length

  end

  test "starts_at has to happend before ends_at" do

    #setup


    #exercise

    #verify

    #teardown

  end

  test "validation for event attributes" do

  event_empty = Event.new()
  event_with_unvalid_kind = Event.new(kind: 'not_valid', starts_at: DateTime.parse("2014-08-04 09:30"), ends_at: DateTime.parse("2014-08-04 12:30"))
  event_without_kind = Event.new(starts_at: DateTime.parse("2014-08-04 09:30"), ends_at: DateTime.parse("2014-08-04 12:30"))
  event_correct_for_validations = Event.new(kind: 'appointment', starts_at: DateTime.parse("2014-08-11 10:30"), ends_at: DateTime.parse("2014-08-11 11:30"), weekly_recurring: true)

  assert_equal event_empty.save, false
  assert_equal event_with_unvalid_kind.save, false
  assert_equal event_without_kind.save, false
  assert_equal event_correct_for_validations.save, true

  end


end
