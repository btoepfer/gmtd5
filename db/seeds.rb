# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

50.times do |u|
  User.create!(
    id:       u+101,
    username: "#{Faker::Internet.user_name()}#{u}"[0,11],
    email:    "#{Faker::Internet.user_name}#{u}@#{Faker::Internet.domain_name}",
    password: Faker::Internet.password(8,12),
    confirmed_at: Time.now,
    language: "en"
    )
    10000.times do |n|
      Note.create(
        user_id: u+101, 
        title:   Faker::Lorem.sentence,
        content: Faker::Lorem.paragraph
      )
    end
end