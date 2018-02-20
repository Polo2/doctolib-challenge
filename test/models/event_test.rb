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

  test "testing the method fill_slots_for_appointments" do

    opening_event_with_recurrence = Event.create kind: 'opening', starts_at: DateTime.parse("2014-08-04 09:30"), ends_at: DateTime.parse("2014-08-04 12:30"), weekly_recurring: true
    opening_event_without_recurrence = Event.create kind: 'opening', starts_at: DateTime.parse("2014-08-12 14:00"), ends_at: DateTime.parse("2014-08-12 17:30")

    opening_event_with_recurrence.fill_slots_for_appointments
    opening_event_without_recurrence.fill_slots_for_appointments


    assert_equal 6, opening_event_with_recurrence.fill_slots_for_appointments.length
    assert_equal "09:30", opening_event_with_recurrence.fill_slots_for_appointments[0]
    assert_equal "12:00", opening_event_with_recurrence.fill_slots_for_appointments[-1]

    assert_equal 7, opening_event_without_recurrence.fill_slots_for_appointments.length
    assert_equal "14:00", opening_event_without_recurrence.fill_slots_for_appointments[0]
    assert_equal "17:00", opening_event_without_recurrence.fill_slots_for_appointments[-1]

  end

  test "testing the method fill_slots_for_openings" do

    appointment_event = Event.create kind: 'appointment', starts_at: DateTime.parse("2014-08-11 10:30"), ends_at: DateTime.parse("2014-08-11 11:30")
    appointment_event.fill_slots_for_openings
    assert_equal 2, appointment_event.fill_slots_for_openings.length
    assert_equal "10:30", appointment_event.fill_slots_for_openings[0]
    assert_equal "11:00", appointment_event.fill_slots_for_openings[-1]

  end

  test "appointment duration is not a multiple of 30 minutes" do
    # for the doctor, every half_hour started is due

    appointment_event = Event.create kind: 'appointment', starts_at: DateTime.parse("2014-08-11 10:30"), ends_at: DateTime.parse("2014-08-11 11:03")

    assert_equal 2, appointment_event.fill_slots_for_openings.length
    assert_equal "11:00", appointment_event.fill_slots_for_openings[-1]

  end

  test "starts_at has to happend before ends_at" do

    event_with_time_error = Event.new(kind: 'opening', starts_at: DateTime.parse("2014-08-10 09:30"), ends_at: DateTime.parse("2014-08-04 12:30"))
    assert_equal  event_with_time_error.save, false

  end

  test "validation of event's attributes" do

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
