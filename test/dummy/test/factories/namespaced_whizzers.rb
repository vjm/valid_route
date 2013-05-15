# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :namespaced_whizzer, :class => 'Namespaced::Whizzer' do
    permalink "MyString"
  end
end
