require 'faker'

10.times do |i|

  Account.create(username: Faker::Name.name,
                 password: "password",
                 password_confirmation: "password",
                 email: Faker::Internet.email)

  Doctor.create(name: Faker::Name.name,
                fax: "+1-800-555-555#{i}",
                comments: Faker::Lorem.sentence,
                email: Faker::Internet.email)


  Account.last.diabetics.create(name: Faker::Name.name,
                                email: Faker::Internet.email,
                                birthday: Date.today - rand(2000))


  Diabetic.last.preference = Preference.create(reminders: true,
                                   frequency: (i + 1))
  3.times do
    st1 = Time.now
    7.times do |j|
      st2 = Time.now
      st_dif = st2 - st1
      Diabetic.last.records.create(weight: "#{rand(180...200)}",
                                   glucose: rand(75..100).to_s,
                                   taken_at: DateTime.now - (j) - st_dif,
                                   comment: "This works and it is awesome don't you think#{j}")
    end
  end
end


Account.create(
                username: 'test',
                email: 'test@test.com',
                password: 'testtest',
                password_confirmation: 'testtest'
                )

Account.last.diabetics.create(
                              name: 'quentin',
                              email: 'test@test.com',
                              birthday: Date.parse('1986-10-15')
                              )

puts "Result : "
puts "#{Account.count} accounts - Last : #{Account.last.username} - #{Account.last.email}"
puts "#{Diabetic.count} diabetics - Last : #{Diabetic.last.name} - #{Diabetic.last.email} - born on #{Diabetic.last.birthday}"
