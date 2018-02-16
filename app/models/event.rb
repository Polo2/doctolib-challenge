class Event < ApplicationRecord
  APPOINTMENT_DURATION_IN_MINUTES = 30
  DAYS_EXPECTED = 7

  validates :kind, presence: true, inclusion: { in: %w(opening appointment), message: "not a valid kind" }
  validates :starts_at, presence: true
  validates :ends_at, presence: true
  validates :weekly_recurring, inclusion: { in: [true, false, nil], message: "not a valid weekly recurring information" }

  def self.availabilities(first_day_date)
    @week_schedule = []
    DAYS_EXPECTED.times { |day_index| @week_schedule << { day: first_day_date + day_index, openings: [], appointments: [], slots: [] } }

    openings_with_recurrence = self.where(kind: "opening", weekly_recurring: true)
    openings_with_recurrence.each do |opening_event|
      @week_schedule[(opening_event.starts_at.day - first_day_date.day) % 7][:openings] << opening_event.fill_slots_for_openings
    end

    openings_without_recurrence = self.where(kind: "opening", weekly_recurring: nil).select { |opening| opening.starts_at >= first_day_date && opening.starts_at < first_day_date + 7 }
    openings_without_recurrence.each do |opening_event|
      @week_schedule[opening_event.starts_at.day - first_day_date.day][:openings] << opening_event.fill_slots_for_openings
    end

    appointments = self.where(kind: "appointment").select { |appointment| appointment.starts_at >= first_day_date && appointment.starts_at < first_day_date + 7 }
    appointments.each do |appointment_event|
      @week_schedule[appointment_event.starts_at.day - first_day_date.day][:appointments] << appointment_event.fill_slots_for_appointments
    end

    @week_schedule = @week_schedule.map do |schedule|
      slots_per_day = schedule[:openings].empty? ? [] : schedule[:openings][0].select { |time| !schedule[:appointments][0].include?(time) }
      { date: schedule[:day], slots: slots_per_day.sort }
    end

    # cleaning for test 9:30 != 09:30
    @week_schedule.map { |jour| { date: jour[:date], slots: jour[:slots].map { |time| time[0] == "0" ? time.split("")[1..-1].join("") : time } } }
  end

  def fill_slots_for_appointments
    var_time = self.starts_at
    end_time = self.ends_at
    appointments = []

    while var_time < end_time
      appointments << var_time.strftime("%H:%M")
      var_time += APPOINTMENT_DURATION_IN_MINUTES * 60
    end
    appointments
  end

  def fill_slots_for_openings
    var_time = self.starts_at
    end_time = self.ends_at
    openings = []
    while var_time < end_time
      openings << var_time.strftime("%H:%M")
      var_time += APPOINTMENT_DURATION_IN_MINUTES * 60
    end
    openings
  end
end
