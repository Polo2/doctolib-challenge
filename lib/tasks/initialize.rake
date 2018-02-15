puts "nettoyage DB"
Event.destroy_all

puts "c'est darty"


ope1 = Event.create kind: 'opening', starts_at: DateTime.parse("2014-08-04 09:30"), ends_at: DateTime.parse("2014-08-04 12:30"), weekly_recurring: true
ope2 = Event.create kind: 'opening', starts_at: DateTime.parse("2014-08-13 14:00"), ends_at: DateTime.parse("2014-08-13 17:30")
ope3 = Event.create kind: 'opening', starts_at: DateTime.parse("2014-09-13 14:00"), ends_at: DateTime.parse("2014-09-13 17:30")
app = Event.create kind: 'appointment', starts_at: DateTime.parse("2014-08-11 10:30"), ends_at: DateTime.parse("2014-08-11 11:30")


p Event.availabilities DateTime.parse("2014-08-10")
