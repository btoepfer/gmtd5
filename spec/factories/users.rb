FactoryGirl.define do
  factory :user do
    id 1
    username "Test User"
    email "test@example.com"
    password "please123"
    confirmed_at Time.now
    language "en"
  end
  

end
