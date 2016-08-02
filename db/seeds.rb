# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
if Exercise.count == 0
  Exercise.create!( name: "Crunches"    , exercise_index: 20)
  Exercise.create!( name: "Walking"	    , exercise_index: 15)
  Exercise.create!( name: "Running"	    , exercise_index: 40)
  Exercise.create!( name: "Sprinting"	  , exercise_index: 60)
  Exercise.create!( name: "Squats"	    , exercise_index: 60)
  Exercise.create!( name: "Bench press"	, exercise_index: 45)
end
