class Event < ApplicationRecord


  def self.availabilities(first_day_date)
    seven_days_array = []
    last_day_date = first_day_date + 6

    7.times do |day_index|
     seven_days_array << {day: first_day_date + day_index, openings: [], appointments: [], slots: []}
     # seven_days_array << Event.create(starts_at: first_day_date + day_index, kind: "availabilities").slots
    end

    openings_with_recurrence = self.where(kind: "opening", weekly_recurring: true)
    openings_with_recurrence.each do |opening_event|
      day_index = (opening_event.starts_at.day - first_day_date.day) % 7
      # seven_days_array[day_index][:openings] << {start: opening_event.starts_at.strftime("%H:%M") ,end: opening_event.ends_at.strftime("%H:%M") }
      seven_days_array[day_index][:slots] << opening_event.starts_at.strftime("%H:%M")
      seven_days_array[day_index][:slots] << opening_event.ends_at.strftime("%H:%M")
    end


    openings_without_recurrence = self.where(kind: "opening", weekly_recurring: nil).select { |opening| opening.starts_at >= first_day_date && opening.starts_at < first_day_date + 7 }
    openings_without_recurrence.each do |opening_event|
      day_index = opening_event.starts_at.day - first_day_date.day
      # seven_days_array[day_index][:openings] << {start: opening_event.starts_at.strftime("%H:%M") ,end: opening_event.ends_at.strftime("%H:%M") }
      seven_days_array[day_index][:slots] << opening_event.starts_at.strftime("%H:%M")
      seven_days_array[day_index][:slots] << opening_event.ends_at.strftime("%H:%M")
    end

    appointments = self.where(kind: "appointment").select { |appointment| appointment.starts_at >= first_day_date && appointment.starts_at < first_day_date + 7 }
    appointments.each do |appointment_event|
      day_index = appointment_event.starts_at.day - first_day_date.day
      # seven_days_array[day_index][:appointments] << {start: appointment_event.starts_at.strftime("%H:%M") ,end: appointment_event.ends_at.strftime("%H:%M") }
      seven_days_array[day_index][:slots] << appointment_event.starts_at.strftime("%H:%M")
      seven_days_array[day_index][:slots] << appointment_event.ends_at.strftime("%H:%M")
    end

    seven_days_array.each do |day|
      day[:slots].sort!
    end

    seven_days_array

  end

  # def slots
  #   slots = []
  #   self[:openings].each do |element|
  #     slots << element[:start]
  #     slots << element[:end]
  #   end
  #   self[:appointments].each do |element|
  #     slots << element[:start]
  #     slots << element[:end]
  #   end
  #   slots.sort
  # end
# pour chaque rdv deja pris, je trouve dans le stableau slots l'heure de rdv la plus proche, et je viens ajouter "contre" ce nv rdv

  def scan_opening
    openings = []
    openings << Event.where(kind: "opening", weekly_recurring: "true")
    openings
  end

private


end


# .map { |event| event.starts_at }
