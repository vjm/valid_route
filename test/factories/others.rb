# Read about factories at https://github.com/thoughtbot/factory_girl

# This will guess the Page class
FactoryGirl.define do
	factory :other do
		name { Faker::Name.name }
		permalink { Faker::Name.name.parameterize }
		content { Faker::Lorem.words(15).join(" ") }
	end

end