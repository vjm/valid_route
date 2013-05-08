# Read about factories at https://github.com/thoughtbot/factory_girl

# This will guess the Page class
FactoryGirl.define do
	factory :page do
		name { Faker::Name.name }
		permalink { Faker::Name.name.parameterize }
		content { Faker::Lorem.words(15).join(" ") }

		factory :home_page do
			name "Home"
			permalink "home"
			content "This is the homepage!"
		end

		factory :contact_page do
			name "Contact"
			permalink "contact"
			content "This is the contact page!"
		end
	end

end