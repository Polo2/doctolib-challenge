puts "nettoyage DB"
Event.destroy_all

puts "lancement du test"


Event.create kind: 'opening', starts_at: DateTime.parse("2014-08-04 09:30"), ends_at: DateTime.parse("2014-08-04 12:30"), weekly_recurring: true
Event.create kind: 'appointment', starts_at: DateTime.parse("2014-08-11 10:30"), ends_at: DateTime.parse("2014-08-11 11:30")

availabilities = Event.availabilities DateTime.parse("2014-08-10")

puts "test1"
puts Date.new(2014, 8, 10) == availabilities[0][:date]

puts "test2"
puts availabilities[0][:slots] == []

puts "test3"
puts Date.new(2014, 8, 11) == availabilities[1][:date]

puts "test4"

puts availabilities[1][:slots] == ["9:30", "10:00", "11:30", "12:00"]


puts "test5"
puts Date.new(2014, 8, 16) == availabilities[6][:date]

puts "test6"
puts availabilities.length == 7

