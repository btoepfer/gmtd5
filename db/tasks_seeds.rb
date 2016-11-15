# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

20.times do |t|
  Task.create!(
    id:       t+200,
    user_id:  7,
    due_date: Faker::Date.forward(23),
    name: Faker::Lorem.sentence(3),
    status: t % 3,
    content: Faker::Lorem.sentence(30)
    )
end