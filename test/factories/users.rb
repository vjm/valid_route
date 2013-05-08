# This will guess the User class
FactoryGirl.define do

  factory :user do

    sequence(:username, 1) {|n| "#{Faker::Lorem.word}#{n}" }
    first_name { Faker::Name.first_name }
    # last_name { Faker::Name.last_name }
    password "weekend"
    # password_confirmation "weekend"
    # sequence(:phone, 1000) {|n| "617470#{n}" } # 6174701000
    # email { "#{first_name}.#{last_name}@factoriedusers.com".downcase }
    # role "user"
    
  
  	factory :webmaster do
	    # email { "#{first_name}.#{last_name}@factoriedwebmasters.com".downcase }
	    # role "webmaster"
    end

    # factory do :user_with_identities

    #   ignore do
    #     identities_count 1 # if this is greater than one, it could potentially duplicate providers right now
    #   end

    #   after(:create) do |user, evaluator|
    #     FactoryGirl.create_list(:identity, evaluator.identities_count, user: user)
    #   end

    # end
  end

end